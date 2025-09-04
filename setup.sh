#!/bin/bash

SCRIPT_DIR="/opt/autoinstall"

. /opt/autoinstall/scripts/common/colors.sh
. /opt/autoinstall/scripts/common/functions.sh
. /opt/autoinstall/scripts/common/languages.sh

menu() {
    echo -e "${BOLD_MAGENTA}$1${RESET}"
}

question() {
    echo -e "${BOLD_CYAN}$1${RESET}"
}

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

print_header() {
    clear
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo -e "\033[1;32m"
    echo -e "┌────────────────────────────────────────────────────────────────────┐"
    echo -e "│   ██████╗  ██╗  ██╗ ██████╗ ██╗  ██╗                                        │"
    echo -e "│   ███╗   ███╗██████╗ ███████╗██╗███████╗██████╗ ██████╗  ██████╗    │"
    echo -e "│   ████╗ ████║██╔══██╗██╔════╝██║██╔════╝██╔══██╗██╔══██╗██╔═══██╗    │"
    echo -e "│   ██╔████╔██║██████╔╝█████╗  ██║█████╗  ██████╔╝██████╔╝██║   ██║    │"
    echo -e "│   ██║╚██╔╝██║██╔══██╗██╔══╝  ██║██╔══╝  ██╔══██╗██╔══██╗██║   ██║    │"
    echo -e "│   ██║ ╚═╝ ██║██║  ██║██║     ██║███████╗██║  ██║██║  ██║╚██████╔╝    │"
    echo -e "│   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝    │"                                                                                                                                       
    echo -e "└───────────────────────────────────────────────────────────────────┘"
    echo -e "\033[0m"
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    if [ "$LANGUAGE" = "en" ]; then
        echo -e "${GREEN}AutoInstall by gko11${RESET}"
        echo -e "${CYAN}Project: https://github.com/gko11/AutoInstall${RESET}"
        echo -e "${YELLOW}Contacts: @mrfierros${RESET}"
        echo -e "${CYAN}Version: 1.0${RESET}"
        echo
        echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
        echo -e "${YELLOW}Made with support from:${RESET}"
        echo -e "${CYAN}GitHub SoloBot: https://github.com/Vladless/Solo_bot${RESET}"
        echo -e "${YELLOW}Contacts: @Vladless${RESET}"
	echo
	echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
	echo -e "${GREEN}RemnaSetup by capybara${RESET}"
        echo -e "${CYAN}Project: https://github.com/Capybara-z/RemnaSetup${RESET}"
        echo -e "${YELLOW}Contacts: @KaTTuBaRa${RESET}"
        echo -e "${CYAN}Version: 2.5${RESET}"
    else
        echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
        echo -e "${GREEN}AutoInstall by gko11${RESET}"
        echo -e "${CYAN}Проект: https://github.com/gko11/AutoInstall${RESET}"
        echo -e "${YELLOW}Контакты: @mrfierros${RESET}"
        echo -e "${CYAN}Версия: 1.0${RESET}
       	echo
        echo -e "${GREEN}RemnaSetup by capybara${RESET}"
        echo -e "${CYAN}Проект: https://github.com/Capybara-z/RemnaSetup${RESET}"
        echo -e "${YELLOW}Контакты: @KaTTuBaRa${RESET}"
        echo -e "${CYAN}Версия: 2.5${RESET}"
        echo
        echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
        echo -e "${YELLOW}Сделано при поддержке проекта:${RESET}"
        echo -e "${CYAN}GitHub SoloBot: https://github.com/Vladless/Solo_bot${RESET}"
        echo -e "${YELLOW}Контакты: @Vladless${RESET}"
	
    fi
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo
}


display_main_menu() {
    clear
    print_header
    menu "$(get_string "main_menu")"
    if [ "$LANGUAGE" = "en" ]; then
        echo -e "${BLUE}1. Setting up a server with a bot${RESET}"
        echo -e "${BLUE}2. Setting up a server with the panel${RESET}"
        echo -e "${BLUE}3. Setting up a node server${RESET}"
        echo -e "${RED}0. Exit${RESET}"
    else
        echo -e "${BLUE}1. Настройка сервера с ботом${RESET}"
        echo -e "${BLUE}2. Настройка сервера с панелью${RESET}"
        echo -e "${BLUE}3. Настройка сервера ноды${RESET}"
        echo -e "${RED}0. Выход${RESET}"
    fi
    echo
    read -p "$(echo -e "${BOLD_CYAN}$(get_string "select_option"):${RESET}") " MAIN_OPTION
    echo
}

run_script() {
    local script="$1"
    if [ -f "$script" ]; then
        bash "$script"
        local result=$?
        if [ "$result" -ne 0 ]; then
            warn "$(get_string "script_error")"
            read -n 1 -s -r -p "$(get_string "press_any_key")"
            echo
        fi
    else
        error "$(get_string "script_not_found"): $script"
        read -n 1 -s -r -p "$(get_string "press_any_key")"
        echo
    fi
}

main 