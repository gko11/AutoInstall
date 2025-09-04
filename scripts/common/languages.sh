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
LANG_STRINGS["en_install_bot_reinstall_denied"]="Remnawave reinstallation denied"
LANG_STRINGS["en_install_bot_subscription_detected"]="Subscription page installation detected"
LANG_STRINGS["en_install_bot_subscription_reinstall"]="Reinstall subscription page? (y/n):"
LANG_STRINGS["en_install_bot_subscription_reinstall_denied"]="Subscription page reinstallation denied"
LANG_STRINGS["en_install_bot_caddy_detected"]="Caddy installation detected"
LANG_STRINGS["en_install_bot_caddy_reinstall"]="Reinstall Caddy? (y/n):"
LANG_STRINGS["en_install_bot_caddy_reinstall_denied"]="Caddy reinstallation denied"
LANG_STRINGS["en_install_bot_no_components"]="No components to install"
LANG_STRINGS["en_install_bot_need_protection"]="Do you need panel protection with custom path (Without protection /api/* and /api/sub/*)? (y/n):"
LANG_STRINGS["en_install_bot_enter_panel_domain"]="Enter panel domain (e.g., panel.domain.com):"
LANG_STRINGS["en_install_bot_domain_empty"]="Panel domain cannot be empty. Please enter a value."
LANG_STRINGS["en_install_bot_enter_sub_domain"]="Enter subscription domain (e.g., sub.domain.com):"
LANG_STRINGS["en_install_bot_enter_panel_port"]="Enter panel port (default 3000):"
LANG_STRINGS["en_install_bot_enter_sub_port"]="Enter subscription port (default 3010):"
LANG_STRINGS["en_install_bot_enter_project_name"]="Enter project name:"
LANG_STRINGS["en_install_bot_project_name_empty"]="Project name cannot be empty. Please enter a value."
LANG_STRINGS["en_install_bot_enter_project_description"]="Enter subscription page description:"
LANG_STRINGS["en_install_bot_project_description_empty"]="Project description cannot be empty. Please enter a value."
LANG_STRINGS["en_install_bot_enter_login_route"]="Enter panel access path (e.g., supersecretroute):"
LANG_STRINGS["en_install_bot_login_route_empty"]="Panel access path cannot be empty. Please enter a value."
LANG_STRINGS["en_install_bot_enter_admin_login"]="Enter administrator login:"
LANG_STRINGS["en_install_bot_admin_login_empty"]="Administrator login cannot be empty. Please enter a value."
LANG_STRINGS["en_install_bot_enter_admin_email"]="Enter administrator email:"
LANG_STRINGS["en_install_bot_admin_email_empty"]="Administrator email cannot be empty. Please enter a value."
LANG_STRINGS["en_install_bot_enter_admin_password"]="Enter administrator password (min. 8 characters, at least one uppercase, lowercase, number and special character):"
LANG_STRINGS["en_install_bot_password_short"]="Password too short! Minimum 8 characters."
LANG_STRINGS["en_install_bot_password_uppercase"]="Password must contain at least one uppercase letter (A-Z)."
LANG_STRINGS["en_install_bot_password_lowercase"]="Password must contain at least one lowercase letter (a-z)."
LANG_STRINGS["en_install_bot_password_number"]="Password must contain at least one number (0-9)."
LANG_STRINGS["en_install_bot_password_special"]="Password must contain at least one special character (!, @, #, $, %, ^, &, *, -, +, =, ? etc.)."
LANG_STRINGS["en_install_bot_installing"]="Installing Remnawave..."
LANG_STRINGS["en_install_bot_installing_with_protection"]="Installing Remnawave with protection..."
LANG_STRINGS["en_install_bot_installing_subscription"]="Installing subscription page..."
LANG_STRINGS["en_install_bot_installing_subscription_with_protection"]="Installing subscription page with protection..."
LANG_STRINGS["en_install_bot_installing_caddy"]="Installing Caddy..."
LANG_STRINGS["en_install_bot_installing_caddy_with_protection"]="Installing Caddy with protection..."
LANG_STRINGS["en_install_bot_docker_already_installed"]="Docker is already installed, skipping installation."
LANG_STRINGS["en_install_bot_complete"]="Installation completed!"
LANG_STRINGS["en_install_bot_panel_info_header"]="Panel Access Information"
LANG_STRINGS["en_install_bot_panel_url"]="Panel URL:"
LANG_STRINGS["en_install_bot_email"]="Email:"
LANG_STRINGS["en_install_bot_username"]="Username:"
LANG_STRINGS["en_install_bot_password"]="Password:"
LANG_STRINGS["en_install_bot_press_key"]="Press any key to return to menu..."
LANG_STRINGS["en_install_bot_please_enter_yn"]="Please enter only 'y' or 'n'"

LANG_STRINGS["ru_install_bot_detected"]="Обнаружена установка vsftpd"
LANG_STRINGS["ru_install_bot_reinstall"]="Переустановить vsftpd? (y/n):"
LANG_STRINGS["ru_install_bot_stopping"]="Останавливаем и удаляем существующую установку..."
LANG_STRINGS["ru_install_bot_reinstall_denied"]="Отказано в переустановке VSFTPD"
LANG_STRINGS["ru_install_bot_subscription_detected"]="Обнаружена установка страницы подписок"
LANG_STRINGS["ru_install_bot_subscription_reinstall"]="Переустановить страницу подписок? (y/n):"
LANG_STRINGS["ru_install_bot_subscription_reinstall_denied"]="Отказано в переустановке страницы подписок"
LANG_STRINGS["ru_install_bot_caddy_detected"]="Обнаружена установка Caddy"
LANG_STRINGS["ru_install_bot_caddy_reinstall"]="Переустановить Caddy? (y/n):"
LANG_STRINGS["ru_install_bot_caddy_reinstall_denied"]="Отказано в переустановке Caddy"
LANG_STRINGS["ru_install_bot_no_components"]="Нет компонентов для установки"
LANG_STRINGS["ru_install_bot_need_protection"]="Требуется ли защита панели кастомным путем (Без защиты /api/* и /api/sub/*)? (y/n):"
LANG_STRINGS["ru_install_bot_enter_panel_domain"]="Введите домен панели (например, panel.domain.com):"
LANG_STRINGS["ru_install_bot_domain_empty"]="Домен панели не может быть пустым. Пожалуйста, введите значение."
LANG_STRINGS["ru_install_bot_enter_sub_domain"]="Введите домен подписок (например, sub.domain.com):"
LANG_STRINGS["ru_install_bot_enter_panel_port"]="Введите порт панели (по умолчанию 3000):"
LANG_STRINGS["ru_install_bot_enter_sub_port"]="Введите порт подписок (по умолчанию 3010):"
LANG_STRINGS["ru_install_bot_enter_project_name"]="Введите имя проекта:"
LANG_STRINGS["ru_install_bot_project_name_empty"]="Имя проекта не может быть пустым. Пожалуйста, введите значение."
LANG_STRINGS["ru_install_bot_enter_project_description"]="Введите описание страницы подписки:"
LANG_STRINGS["ru_install_bot_project_description_empty"]="Описание проекта не может быть пустым. Пожалуйста, введите значение."
LANG_STRINGS["ru_install_bot_enter_login_route"]="Введите путь доступа к панели (например, supersecretroute):"
LANG_STRINGS["ru_install_bot_login_route_empty"]="Путь доступа к панели не может быть пустым. Пожалуйста, введите значение."
LANG_STRINGS["ru_install_bot_enter_admin_login"]="Введите логин администратора:"
LANG_STRINGS["ru_install_bot_admin_login_empty"]="Логин администратора не может быть пустым. Пожалуйста, введите значение."
LANG_STRINGS["ru_install_bot_enter_admin_email"]="Введите email администратора:"
LANG_STRINGS["ru_install_bot_admin_email_empty"]="Email администратора не может быть пустым. Пожалуйста, введите значение."
LANG_STRINGS["ru_install_bot_enter_admin_password"]="Введите пароль администратора (мин. 8 символов, хотя бы одна заглавная, строчная, цифра и спецсимвол):"
LANG_STRINGS["ru_install_bot_password_short"]="Пароль слишком короткий! Минимум 8 символов."
LANG_STRINGS["ru_install_bot_password_uppercase"]="Пароль должен содержать хотя бы одну заглавную букву (A-Z)."
LANG_STRINGS["ru_install_bot_password_lowercase"]="Пароль должен содержать хотя бы одну строчную букву (a-z)."
LANG_STRINGS["ru_install_bot_password_number"]="Пароль должен содержать хотя бы одну цифру (0-9)."
LANG_STRINGS["ru_install_bot_password_special"]="Пароль должен содержать хотя бы один специальный символ (!, @, #, $, %, ^, &, *, -, +, =, ? и т.д.)."
LANG_STRINGS["ru_install_bot_installing"]="Установка Remnawave..."
LANG_STRINGS["ru_install_bot_installing_with_protection"]="Установка Remnawave с защитой..."
LANG_STRINGS["ru_install_bot_installing_subscription"]="Установка страницы подписок..."
LANG_STRINGS["ru_install_bot_installing_subscription_with_protection"]="Установка страницы подписок с защитой..."
LANG_STRINGS["ru_install_bot_installing_caddy"]="Установка Caddy..."
LANG_STRINGS["ru_install_bot_installing_caddy_with_protection"]="Установка Caddy с защитой..."
LANG_STRINGS["ru_install_bot_docker_already_installed"]="Docker уже установлен, пропускаем установку."
LANG_STRINGS["ru_install_bot_complete"]="Установка завершена!"
LANG_STRINGS["ru_install_bot_panel_info_header"]="Информация для доступа к панели"
LANG_STRINGS["ru_install_bot_panel_url"]="URL панели:"
LANG_STRINGS["ru_install_bot_email"]="Email:"
LANG_STRINGS["ru_install_bot_username"]="Логин:"
LANG_STRINGS["ru_install_bot_password"]="Пароль:"
LANG_STRINGS["ru_install_bot_press_key"]="Нажмите любую клавишу для возврата в меню..."
LANG_STRINGS["ru_install_bot_please_enter_yn"]="Пожалуйста, введите только 'y' или 'n'"


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