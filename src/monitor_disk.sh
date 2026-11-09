#!/usr/bin/env bash

# Import log and die function
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

TEAMS_WEBHOOK_URL="${TEAMS_WEBHOOK_URL:-}"

usage_limit=85
hostname="$(hostname)"
origin="${ORIGIN:-unknown}"

getPartitionOverLimit() {
	df -P \
        | awk -v limit="$usage_limit" -v OFS='\t' \
            'NR > 1 && $5+0 >= limit { print $1, $6, $5+0 }'
}

buildPartitionTable() {
    {
        printf '%s\t%s\t%s\n' "PARTITION" "MOUNTED ON" "USAGE" 
        awk -F'\t' -v OFS='\t' '{ print $1, $2, $3 "%" }'
    } | column -t -s $'\t'
}

buildPayload() {
	jq -R -n --arg host "$hostname" --argjson limit "$usage_limit" '
        {
		    notification_type: "over limit partition",
            host: $host,
            limit: $limit,
            partitions: [ 
                inputs 
                | select(length > 0)
                | split("\t")
                | {partition: .[0], mount: .[1], use: (.[2] | tonumber)}
            ]
   		}'
}

main() {
    cmdRequire jq curl column df awk

    if [[ "$origin" == "CRON" && -z "$TEAMS_WEBHOOK_URL " ]]; then
        die "Teams webhook not found (verify .env)"
    fi

	log INFO "Monitoring process initializing (Origin: $origin)..."

	local partitions="$(getPartitionOverLimit)"	
    [[ -n "$partitions" ]] || { log INFO "No partition above $usage_limit% on $hostname"; return 0; }
	    
    if [[ "$origin" == "CRON" ]]; then
        buildPayload <<< "$partitions" | {
            local payload
            payload="$(cat)"
            sendAlert "$payload"
            
            log INFO "Alert sent"
        }

        exit 0
    fi        

    log WARNING "The following partitions are above $usage_limit% on $hostname:"
    buildPartitionTable <<< "$partitions"
}

main "$@"
