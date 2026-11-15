#!/usr/bin/env bash

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

getEnvFile() {
    if [[ -f "$LIB_DIR/.env" ]]; then
        set -a
        source "$LIB_DIR/.env"
        set +a
    fi
}

log() { printf '%s [%s] %s\n' "$(date '+%F %H:%M:%S')" "$1" "${*:2}" >&2; }

die() { log ERROR "$*"; exit 1; }

sendAlert() {
	local payload="$1"
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

getOSPkgManager() {
    local pkg_managers=("apt-get" "pacman" "brew")
    local m
    
    for m in "${pkg_managers[@]}"; do
        if command -v "$m" >/dev/null 2>&1; then
            printf '%s\n' "$m"
            return 0
        fi
    done 

    return 1
}
