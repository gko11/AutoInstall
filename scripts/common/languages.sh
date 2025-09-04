#!/bin/bash

. /opt/autoinstall/scripts/common/colors.sh

LANGUAGE_FILE="/opt/autoinstall/.language"

if [ -f "$LANGUAGE_FILE" ]; then
    LANGUAGE=$(cat "$LANGUAGE_FILE")
fi

select_language() {
    if [ -z "$LANGUAGE" ] || [ "$LANGUAGE" != "en" ] && [ "$LANGUAGE" != "ru" ]; then
        while true; do
            clear
            echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
            echo -e "${BOLD_CYAN}Select language / Выберите язык:${RESET}"
            echo -e "${BLUE}1) English${RESET}"
            echo -e "${BLUE}2) Русский${RESET}"
            echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
`            read -p "$(echo -e "${BOLD_CYAN}Enter your choice (1-2) / Введите ваш выбор (1-2):${RESET}") " lang_choice

            case $lang_choice in
                1)
                    LANGUAGE="en"
                    break
                    ;;
                2)
                    LANGUAGE="ru"
                    break
                    ;;
                *)
                    echo -e "${BOLD_RED}Invalid choice. Please select 1 for English or 2 for Russian.${RESET}"
                    echo -e "${BOLD_RED}Неверный выбор. Пожалуйста, выберите 1 для Английского или 2 для Русского.${RESET}"
                    sleep 2
                    ;;
            esac
        done
        echo "$LANGUAGE" > "$LANGUAGE_FILE"
    fi
}

declare -A LANG_STRINGS

# AutoInstall
LANG_STRINGS["en_main_menu"]="Main Menu"

LANG_STRINGS["ru_main_menu"]="Главное меню"

get_string() {
    local key="$1"
    local lang_key="${LANGUAGE}_${key}"
    local string="${LANG_STRINGS[$lang_key]}"
    
    shift
    if [ $# -gt 0 ]; then
        printf "$string" "$@"
    else
        echo "$string"
    fi
}

select_language 