#!/bin/bash

source "/opt/autoinstall/scripts/common/colors.sh"
source "/opt/autoinstall/scripts/common/functions.sh"
source "/opt/autoinstall/scripts/common/languages.sh"

REINSTALL_VSFTPD=false
REINSTALL_UFW=false
REINSTALL_BOT=false

check_component() {
    local component=$1
    local path=$2
    local file=$3

    case $component in
        "vsftpd")
            if command -v vsftpd >/dev/null 2>&1 && [ -f "$file" ]; then
    		info "$(get_string "install_bot_detected_vsftpd")"
		while true; do
                    question "$(get_string "install_bot_reinstall_vsftpd")"
                    REINSTALL="$REPLY"
                    if [[ "$REINSTALL" == "y" || "$REINSTALL" == "Y" ]]; then
                        warn "$(get_string "install_bot_stopping_vsftpd")"
                        sudo apt purge -y vsftpd
                        rm -f "$file"
                        REINSTALL_VSFTPD=true
                        break
                    elif [[ "$REINSTALL" == "n" || "$REINSTALL" == "N" ]]; then
                        info "$(get_string "install_bot_reinstall_denied_vsftpd")"
                        REINSTALL_VSFTPD=false
                        break
                    else
                        warn "$(get_string "install_bot_please_enter_yn")"
                    fi
		done
	    else
    		REINSTALL_VSFTPD=true
            fi
            ;;
        "ufw")
             if command -v ufw >/dev/null 2>&1 && [ -f "$file" ] && [[ -d "$path" ]]; then
    		info "$(get_string "install_bot_detected_ufw")"
		while true; do
                    question "$(get_string "install_bot_reinstall_ufw")"
                    REINSTALL="$REPLY"
                    if [[ "$REINSTALL" == "y" || "$REINSTALL" == "Y" ]]; then
                        warn "$(get_string "install_bot_stopping_ufw")"
                        sudo apt purge -y ufw
                        rm -f "$file"
                        rm -f "$path"
                        REINSTALL_UFW=true
                        break
                    elif [[ "$REINSTALL" == "n" || "$REINSTALL" == "N" ]]; then
                        info "$(get_string "install_bot_reinstall_denied_ufw")"
                        REINSTALL_UFW=false
                        break
                    else
                        warn "$(get_string "install_bot_please_enter_yn")"
                    fi
		done
	    else
    		REINSTALL_UFW=true
            fi
            ;;
	"solobot")
             if [ -f "$file" ] && [[ -d "$path" ]]; then
    		info "$(get_string "install_bot_detected_solobot")"
		while true; do
		    info "$(get_string "install_bot_atention_solobot")"
                    question "$(get_string "install_bot_reinstall_solobot")"
                    REINSTALL="$REPLY"
                    if [[ "$REINSTALL" == "y" || "$REINSTALL" == "Y" ]]; then
                        warn "$(get_string "install_bot_stopping_solobot")"
                       
                        REINSTALL_BOT=true
                        break
                    elif [[ "$REINSTALL" == "n" || "$REINSTALL" == "N" ]]; then
                        info "$(get_string "install_bot_reinstall_denied_solobot")"
                        REINSTALL_BOT=false
                        break
                    else
                        warn "$(get_string "install_bot_please_enter_yn")"
                    fi
		done
	    else
    		REINSTALL_BOT=true
            fi
            ;;

	esac
}

install_docker() {
    if ! command -v docker &> /dev/null; then
        info "$(get_string "install_full_installing_docker")"
        sudo curl -fsSL https://get.docker.com | sh
    fi
}

generate_64() {
    openssl rand -hex 64
}

generate_24() {
    openssl rand -hex 24
}

generate_login() {
    tr -dc 'a-zA-Z' < /dev/urandom | head -c 15
}



install_without_protection() {
    if [ "$REINSTALL_VSFTPD" = true ]; then
        info "$(get_string "install_full_installing")"
        mkdir -p /opt/remnawave
        cd /opt/remnawave

        cp "/opt/remnasetup/data/docker/panel.env" .env
        cp "/opt/remnasetup/data/docker/panel-compose.yml" docker-compose.yml

        JWT_AUTH_SECRET=$(generate_64)
        JWT_API_TOKENS_SECRET=$(generate_64)
        METRICS_USER=$(generate_login)
        METRICS_PASS=$(generate_64)
        WEBHOOK_SECRET_HEADER=$(generate_64)
        DB_USER=$(generate_login)
        DB_PASSWORD=$(generate_24)

        export DB_USER
        export DB_PASSWORD

        sed -i "s|\$PANEL_DOMAIN|$PANEL_DOMAIN|g" .env
        sed -i "s|\$PANEL_PORT|$PANEL_PORT|g" .env
        sed -i "s|\$METRICS_USER|$METRICS_USER|g" .env
        sed -i "s|\$METRICS_PASS|$METRICS_PASS|g" .env
        sed -i "s|\$DB_USER|$DB_USER|g" .env
        sed -i "s|\$DB_PASSWORD|$DB_PASSWORD|g" .env
        sed -i "s|\$JWT_AUTH_SECRET|$JWT_AUTH_SECRET|g" .env
        sed -i "s|\$JWT_API_TOKENS_SECRET|$JWT_API_TOKENS_SECRET|g" .env
        sed -i "s|\$SUB_DOMAIN|$SUB_DOMAIN|g" .env
        sed -i "s|\$WEBHOOK_SECRET_HEADER|$WEBHOOK_SECRET_HEADER|g" .env

        sed -i "s|\$PANEL_PORT|$PANEL_PORT|g" docker-compose.yml

        docker compose up -d
    fi

    if [ "$REINSTALL_UFW" = true ]; then
        info "$(get_string "install_full_installing_subscription")"
        mkdir -p /opt/remnawave/subscription
        cd /opt/remnawave/subscription

        cp "/opt/remnasetup/data/app-config.json" app-config.json
        cp "/opt/remnasetup/data/docker/subscription-compose.yml" docker-compose.yml

        sed -i "s|\$PANEL_DOMAIN|$PANEL_DOMAIN|g" docker-compose.yml
        sed -i "s|\$SUB_PORT|$SUB_PORT|g" docker-compose.yml
        sed -i "s|\$PROJECT_NAME|$PROJECT_NAME|g" docker-compose.yml
        sed -i "s|\$PROJECT_DESCRIPTION|$PROJECT_DESCRIPTION|g" docker-compose.yml

        docker compose up -d
    fi

    if [ "$REINSTALL_CADDY" = true ]; then
        info "$(get_string "install_full_installing_caddy")"
        mkdir -p /opt/remnawave/caddy
        cd /opt/remnawave/caddy

        cp "/opt/remnasetup/data/caddy/caddyfile" Caddyfile
        cp "/opt/remnasetup/data/docker/caddy-compose.yml" docker-compose.yml

        sed -i "s|\$PANEL_DOMAIN|$PANEL_DOMAIN|g" Caddyfile
        sed -i "s|\$SUB_DOMAIN|$SUB_DOMAIN|g" Caddyfile
        sed -i "s|\$PANEL_PORT|$PANEL_PORT|g" Caddyfile
        sed -i "s|\$SUB_PORT|$SUB_PORT|g" Caddyfile

        docker compose up -d
    fi
}

install_with_protection() {
    if [ "$REINSTALL_VSFTPD" = true ]; then
        info "$(get_string "install_full_installing_with_protection")"
        mkdir -p /opt/remnawave
        cd /opt/remnawave

        cp "/opt/remnasetup/data/docker/panel.env" .env
        cp "/opt/remnasetup/data/docker/panel-compose.yml" docker-compose.yml

        JWT_AUTH_SECRET=$(generate_64)
        JWT_API_TOKENS_SECRET=$(generate_64)
        METRICS_USER=$(generate_login)
        METRICS_PASS=$(generate_64)
        WEBHOOK_SECRET_HEADER=$(generate_64)
        DB_USER=$(generate_login)
        DB_PASSWORD=$(generate_24)

        export DB_USER
        export DB_PASSWORD

        sed -i "s|\$PANEL_DOMAIN|$PANEL_DOMAIN|g" .env
        sed -i "s|\$PANEL_PORT|$PANEL_PORT|g" .env
        sed -i "s|\$METRICS_USER|$METRICS_USER|g" .env
        sed -i "s|\$METRICS_PASS|$METRICS_PASS|g" .env
        sed -i "s|\$DB_USER|$DB_USER|g" .env
        sed -i "s|\$DB_PASSWORD|$DB_PASSWORD|g" .env
        sed -i "s|\$JWT_AUTH_SECRET|$JWT_AUTH_SECRET|g" .env
        sed -i "s|\$JWT_API_TOKENS_SECRET|$JWT_API_TOKENS_SECRET|g" .env
        sed -i "s|\$SUB_DOMAIN|$SUB_DOMAIN|g" .env
        sed -i "s|\$WEBHOOK_SECRET_HEADER|$WEBHOOK_SECRET_HEADER|g" .env

        sed -i "s|\$PANEL_PORT|$PANEL_PORT|g" docker-compose.yml

        docker compose up -d
    fi

    if [ "$REINSTALL_UFW" = true ]; then
        info "$(get_string "install_full_installing_subscription_with_protection")"
        mkdir -p /opt/remnawave/subscription
        cd /opt/remnawave/subscription

        cp "/opt/remnasetup/data/app-config.json" app-config.json
        cp "/opt/remnasetup/data/docker/subscription-protection-compose.yml" docker-compose.yml

        sed -i "s|\$PANEL_PORT|$PANEL_PORT|g" docker-compose.yml
        sed -i "s|\$SUB_PORT|$SUB_PORT|g" docker-compose.yml
        sed -i "s|\$PROJECT_NAME|$PROJECT_NAME|g" docker-compose.yml
        sed -i "s|\$PROJECT_DESCRIPTION|$PROJECT_DESCRIPTION|g" docker-compose.yml

        docker compose up -d
    fi

    if [ "$REINSTALL_CADDY" = true ]; then
        info "$(get_string "install_full_installing_caddy_with_protection")"
        mkdir -p /opt/remnawave/caddy
        cd /opt/remnawave/caddy

        cp "/opt/remnasetup/data/caddy/caddyfile-protection" Caddyfile
        cp "/opt/remnasetup/data/docker/caddy-protection-compose.yml" docker-compose.yml

        sed -i "s|\$PANEL_PORT|$PANEL_PORT|g" Caddyfile
        sed -i "s|\$SUB_DOMAIN|$SUB_DOMAIN|g" Caddyfile
        sed -i "s|\$SUB_PORT|$SUB_PORT|g" Caddyfile

        sed -i "s|\$PANEL_DOMAIN|$PANEL_DOMAIN|g" docker-compose.yml
        sed -i "s|\$CUSTOM_LOGIN_ROUTE|$CUSTOM_LOGIN_ROUTE|g" docker-compose.yml
        sed -i "s|\$LOGIN_USERNAME|$LOGIN_USERNAME|g" docker-compose.yml
        sed -i "s|\$LOGIN_EMAIL|$LOGIN_EMAIL|g" docker-compose.yml
        sed -i "s|\$LOGIN_PASSWORD|$LOGIN_PASSWORD|g" docker-compose.yml

        docker compose up -d
    fi
}

check_docker() {
    if command -v docker >/dev/null 2>&1; then
        info "$(get_string "install_full_docker_already_installed")"
        return 0
    else
        return 1
    fi
}



show_panel_info() {
    echo ""
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo -e "${BOLD_CYAN}$(get_string "install_full_panel_info_header")${RESET}"
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"

    if [ "$NEED_PROTECTION" = "y" ]; then
        echo -e "${BOLD_GREEN}$(get_string "install_full_panel_url")${RESET} ${BLUE}https://${PANEL_DOMAIN}/${CUSTOM_LOGIN_ROUTE}${RESET}"
    else
        echo -e "${BOLD_GREEN}$(get_string "install_full_panel_url")${RESET} ${BLUE}https://${PANEL_DOMAIN}${RESET}"
    fi

    if [ "$NEED_PROTECTION" = "y" ]; then
        echo -e "${BOLD_GREEN}$(get_string "install_full_email")${RESET} ${YELLOW}${LOGIN_EMAIL}${RESET}"
        echo -e "${BOLD_GREEN}$(get_string "install_full_username")${RESET} ${YELLOW}${LOGIN_USERNAME}${RESET}"
        echo -e "${BOLD_GREEN}$(get_string "install_full_password")${RESET} ${YELLOW}${LOGIN_PASSWORD}${RESET}"
    fi
    
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo ""
}

main() {
    check_component "vsftpd" "" "/etc/vsftpd.conf"
    check_component "ufw" "/etc/ufw" "/etc/ufw/sysctl.conf"
    check_component "solobot" "/opt/tg_bot" "/opt/tg_bot/main.py"
    
    if [ "$REINSTALL_VSFTPD" = false ] && [ "$REINSTALL_UFW" = false ] && [ "$REINSTALL_BOT" = false ]; then
        info "$(get_string "install_bot_no_components")"
        read -n 1 -s -r -p "$(get_string "install_bot_press_key")"
        exit 0
    fi
    


    success "$(get_string "install_bot_complete")"

    show_panel_info
    
    read -n 1 -s -r -p "$(get_string "install_bot_press_key")"
    exit 0
}

main
