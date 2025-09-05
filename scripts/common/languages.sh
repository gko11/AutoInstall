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
            read -p "$(echo -e "${BOLD_CYAN}Enter your choice (1-2) / Введите ваш выбор (1-2):${RESET}") " lang_choice

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

# bot-install
LANG_STRINGS["en_install_bot_detected"]="vsftpd installation detected"
LANG_STRINGS["en_install_bot_reinstall"]="Reinstall vsftpd? (y/n):"
LANG_STRINGS["en_install_bot_stopping"]="Stopping and removing existing installation..."
LANG_STRINGS["en_install_bot_reinstall_denied"]="vsftpd reinstallation denied"
LANG_STRINGS["en_install_bot_detected_ufw"]="Ufw installation detected"
LANG_STRINGS["en_install_bot_reinstall_ufw"]="Reinstall ufw? (y/n):"
LANG_STRINGS["en_install_bot_stopping_ufw"]="Stopping and removing existing installation..."
LANG_STRINGS["en_install_bot_reinstall_denied_ufw"]="Ufw reinstallation denied"
LANG_STRINGS["en_install_bot_detected_solobot"]="Solobot installation detected"
LANG_STRINGS["en_install_bot_reinstall_solobot"]="Reinstall Solobot? (y/n):"
LANG_STRINGS["en_install_bot_atention_solobot"]="Attention, the bot will be reinstalled completely, including the database!"
LANG_STRINGS["en_install_bot_stopping_solobot"]="Stopping and removing existing installation..."
LANG_STRINGS["en_install_bot_reinstall_denied_solobot"]="Solobot reinstallation denied"
LANG_STRINGS["en_install_bot_press_key"]="Press any key to return to menu..."
LANG_STRINGS["en_install_bot_please_enter_yn"]="Please enter only 'y' or 'n'"
LANG_STRINGS["en_install_bot_no_components"]="No components to install"
LANG_STRINGS["en_install_bot_complete"]="Installation completed!"



LANG_STRINGS["ru_install_bot_detected_vsftpd"]="Обнаружена установка vsftpd"
LANG_STRINGS["ru_install_bot_reinstall_vsftpd"]="Переустановить vsftpd? (y/n):"
LANG_STRINGS["ru_install_bot_stopping_vsftpd"]="Останавливаем и удаляем существующую установку..."
LANG_STRINGS["ru_install_bot_reinstall_denied_vsftpd"]="Отказано в переустановке VSFTPD"
LANG_STRINGS["ru_install_bot_detected_ufw"]="Обнаружена установка ufw"
LANG_STRINGS["ru_install_bot_reinstall_ufw"]="Переустановить ufw? (y/n):"
LANG_STRINGS["ru_install_bot_stopping_ufw"]="Останавливаем и удаляем существующую установку..."
LANG_STRINGS["ru_install_bot_reinstall_denied_ufw"]="Отказано в переустановке ufw"
LANG_STRINGS["ru_install_bot_detected_solobot"]="Обнаружена установка Solobot"
LANG_STRINGS["ru_install_bot_reinstall_solobot"]="Переустановить Solobot? (y/n):"
LANG_STRINGS["ru_install_bot_atention_solobot"]="Внимание, бот будет переустановлен полностью, включая базу данных!"
LANG_STRINGS["ru_install_bot_stopping_solobot"]="Останавливаем и удаляем существующую установку..."
LANG_STRINGS["ru_install_bot_reinstall_denied_solobot"]="Отказано в переустановке Solobot"
LANG_STRINGS["ru_install_bot_press_key"]="Нажмите любую клавишу для возврата в меню..."
LANG_STRINGS["ru_install_bot_please_enter_yn"]="Пожалуйста, введите только 'y' или 'n'"
LANG_STRINGS["ru_install_bot_no_components"]="Нет компонентов для установки"
LANG_STRINGS["ru_install_bot_complete"]="Установка завершена!"


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