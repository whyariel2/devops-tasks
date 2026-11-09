#!usr/bin/env bash

lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

getEnvFile() {
    if [[ -f "$lib_dir/.env" ]]; then
        set -a
        source "$lib_dir/.env"
        set +a
    fi
}

log() { printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" "${*:2}" >&2; }

die() { log ERROR "$*"; exit 1; }

sendAlert() {
	payload="$1"
	curl -s -X POST -H 'Content-Type: application/json' \
		--data "$payload" "$TEAMS_WEBHOOK_URL" >/dev/null \
        || die "Failed to send alert flow"
}

cmdRequire() {
    local cmd

    for cmd in "$@"; do
        command -v "$cmd" >/dev/null 2>&1 || die "The following command were not found: $cmd"
    done
}
