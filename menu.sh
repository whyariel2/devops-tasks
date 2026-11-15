#!/usr/bin/env bash

set -euo pipefail

# Import cmd_require, log and die function
source "$(dirname "${BASH_SOURCE[0]}")/src/lib.sh"

verifyGum() {
    local pkg_manager="$(getOSPkgManager)" || die "No package manager found"

    if ![[ command -v "gum" >/dev/null 2>&1 ]]; then
        case "$pkg_manager" in
            apt-get) sudo apt-get install -y gum ;;
            pacman) sudo pacman -S --noconfirm gum ;;
            brew) brew install gum ;;
        esac || die "Gum not installed"
   fi
}

menuWelcome() {
    gum style \
        --foreground "#9745F5" --border-foreground "#414141" --border double \
        --align center --width 35 --margin "1 2" --padding "1 0" \
        "Welcome to the DevOps scripts menu! =)"
}

showMenu() {
    gum choose "Backup" "Disk Monitor" --header "Select an option to continuo:"
}

selectMenuOption() {
    local menu_options="Backup=bkp
    Disk Monitor=diskmon"

    local option="$1"

    case "$option" in
        "Backup") src/backup.sh ;;
        "Disk Monitor") ORIGIN=Menu src/disk_monitor.sh ;;
        *) return 1 ;;
    esac || die "$option module not found" 
}

main() {
    verifyGum 
   
    menuWelcome
    
    local choice option
    choice="$(showMenu)"
    option="$(selectMenuOption "$choice")"

}

main "$@"
