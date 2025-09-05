#!/bin/bash

source "/opt/autoinstall/scripts/common/colors.sh"
source "/opt/autoinstall/scripts/common/functions.sh"
source "/opt/autoinstall/scripts/common/languages.sh"

REINSTALL_VSFTPD=false
REINSTALL_VSFTPD_INFO=false
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
                        sudo apt-get purge -y vsftpd > /dev/null
                        rm -f "$file"
                        REINSTALL_VSFTPD=true
			REINSTALL_VSFTPD_INFO=true
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
                        sudo apt-get purge -y ufw > /dev/null
                        rm -f "$file"
                        rm -r "$path"
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
			warn "$(get_string "install_bot_remove_solobot")"
			sudo systemctl stop bot.service > /dev/null
                       	rm -r "$path"
			sudo systemctl stop caddy  > /dev/null
			sudo apt-get purge -y caddy > /dev/null
			sudo systemctl stop postgresql > /dev/null
			sudo apt-get purge postgresql postgresql-contrib -y > /dev/null 
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

install_ftp() {
        info "$(get_string "ru_install_bot_installing_vsftpd")"
	sudo apt-get install vsftpd -y
	rm -f /etc/vsftpd.conf
	cp /opt/autoinstall/configs/vsftpd.conf /etc/vsftpd.conf
	sudo systemctl start vsftpd

	sudo useradd -m -s /bin/bash $FTP_LOGIN_USERNAME
	sudo chpasswd <<<"$FTP_LOGIN_USERNAME:$FTP_LOGIN_PASSWORD"
	echo "$FTP_LOGIN_USERNAME" | sudo tee -a /etc/vsftpd.userlist
	info "$(get_string "install_bot_vsftpd_success")"
	
}

install_ufw() {
	sudo apt install ufw
	sudo ufw allow 22
	sudo ufw allow 80
	sudo ufw allow 443
	sudo ufw allow 3001
	sudo ufw allow 3004
	sudo ufw allow 8443
	sudo ufw allow 20
	sudo ufw allow 21
	sudo ufw allow 8010
	sudo ufw enable -y
	info "$(get_string "install_bot_vsftpd_success")"
	
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

    if [ "$REINSTALL_VSFTPD" == true ] && [ "$REINSTALL_VSFTPD_INFO" == false ]; then
    	while true; do
            question "$(get_string "install_bot_vsftpd")"
            NEED_FTP="$REPLY"
            if [[ "$NEED_FTP" == "y" || "$NEED_FTP" == "Y" ]]; then
                break
            elif [[ "$NEED_FTP" == "n" || "$NEED_FTP" == "N" ]]; then
                break
            else
                warn "$(get_string "install_bot_please_enter_yn")"
            fi
        done
    fi

    if [[ "$NEED_FTP" == "y" || "$NEED_FTP" == "Y" ]] || ([ "$REINSTALL_VSFTPD" == true ] && [ "$REINSTALL_VSFTPD_INFO" == true ]); then
	while true; do
            question "$(get_string "install_bot_enter_vsftpd_login")"
            FTP_LOGIN_USERNAME="$REPLY"
            if [[ -n "$FTP_LOGIN_USERNAME" ]]; then
                break
            fi
            warn "$(get_string "install_bot_vsftpd_login_empty")"
        done       

        while true; do
            question "$(get_string "install_bot_enter_admin_password")"
            FTP_LOGIN_PASSWORD="$REPLY"
            if [[ ${#FTP_LOGIN_PASSWORD} -lt 8 ]]; then
                warn "$(get_string "install_bot_password_short")"
                continue
            fi
            if ! [[ "$FTP_LOGIN_PASSWORD" =~ [A-Z] ]]; then
                warn "$(get_string "install_bot_password_uppercase")"
                continue
            fi
            if ! [[ "$FTP_LOGIN_PASSWORD" =~ [a-z] ]]; then
                warn "$(get_string "install_bot_password_lowercase")"
                continue
            fi
            if ! [[ "$FTP_LOGIN_PASSWORD" =~ [0-9] ]]; then
                warn "$(get_string "install_bot_password_number")"
                continue
            fi
            if ! [[ "$FTP_LOGIN_PASSWORD" =~ [^a-zA-Z0-9] ]]; then
                warn "$(get_string "install_bot_password_special")"
                continue
            fi
            break
        done
    fi

    while true; do
        question "$(get_string "install_bot_ufw")"
        NEED_UFW="$REPLY"
        if [[ "$NEED_UFW" == "y" || "$NEED_UFW" == "Y" ]]; then
            break
        elif [[ "$NEED_UFW" == "n" || "$NEED_UFW" == "N" ]]; then
            break
        else
            warn "$(get_string "install_bot_please_enter_yn")"
        fi
    done

     if [[ "$NEED_FTP" == "y" || "$NEED_FTP" == "Y" ]] || [ "$REINSTALL_VSFTPD" == true ]; then
        install_ftp
     fi

     if [ "$NEED_UFW" == "y" ]; then
        install_ufw
     fi

    
    


    success "$(get_string "install_bot_complete")"

    show_panel_info
    
    read -n 1 -s -r -p "$(get_string "install_bot_press_key")"
    exit 0
}

main
