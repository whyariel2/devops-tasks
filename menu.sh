#!/usr/bin/env bash

set -euo pipefail

# Import cmd_require, log and die function
source "$(dirname "${BASH_SOURCE[0]}")/src/lib.sh"

verifyGum() {
    if ![[ command -v "gum" >/dev/null 2>&1 ]]; then
        case "$pkg_manager" in
            apt-get) sudo apt-get install -y gum ;;
            pacman) sudo pacman -S --noconfirm gum ;;
            brew) brew install gum ;;
        esac || die "Gum not installed"
   fi
}

main() {
    local pkg_manager="$(getOSPkgManager)" || die "No package manager found"
    
    printf '%s\n' "Welcome to my DevOps scripts"
}

main "$@"
