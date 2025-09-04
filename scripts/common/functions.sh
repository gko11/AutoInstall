#!/bin/bash

source "/opt/autoinstall/scripts/common/colors.sh"
source "/opt/autoinstall/scripts/common/languages.sh"

info() {
    echo -e "${BOLD_CYAN}[INFO]${RESET} $1"
}

warn() {
    echo -e "${BOLD_YELLOW}[WARN]${RESET} $1"
}

error() {
    echo -e "${BOLD_RED}[ERROR]${RESET} $1"
}

success() {
    echo -e "${BOLD_GREEN}[SUCCESS]${RESET} $1"
}

menu() {
    echo -e "${BOLD_MAGENTA}$1${RESET}"
    read -p "$(echo -e "${BOLD_CYAN}$(get_string "select_menu_option"):${RESET}") " choice
    echo "$choice"
}

question() {
    read -p "$(echo -e "${BOLD_CYAN}$1${RESET}") " REPLY
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_root() {
    if [ "$(id -u)" != "0" ]; then
        error "$(get_string "root_required")"
        exit 1
    fi
}

check_directory() {
    if [ ! -d "$1" ]; then
        error "$(get_string "directory_not_exist" "$1")"
        exit 1
    fi
}

check_file() {
    if [ ! -f "$1" ]; then
        error "$(get_string "file_not_exist" "$1")"
        exit 1
    fi
}

create_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1.bak"
    fi
}

restore_file() {
    if [ -f "$1.bak" ]; then
        mv "$1.bak" "$1"
    fi
}

export -f info
export -f warn
export -f error
export -f success
export -f menu
export -f question
export -f command_exists
export -f check_root
export -f check_directory
export -f check_file
export -f create_directory
export -f backup_file
export -f restore_file
