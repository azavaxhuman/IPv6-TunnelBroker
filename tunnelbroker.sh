#!/bin/bash
show_menu() {
# ANSI color codes
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# ASCII Art for "DailyDigitalSkills"
echo -e "${GREEN}"
echo "-----------------------------------------------------------------------------"
echo "  _____        _ _       _____  _       _ _        _  _____ _    _ _ _     "
echo " |  __ \      (_) |     |  __ \(_)     (_) |      | |/ ____| |  (_) | |    "
echo " | |  | | __ _ _| |_   _| |  | |_  __ _ _| |_ __ _| | (___ | | ___| | |___ "
echo " | |  | |/ _| | | | | | | |  | |/ /    | | | |  | | |  \|  | / / | | / _|"
echo " | |__| | (_| | | | |_| | |__| | | (_| | | || (_| | |____) |   <| | | \__ "
echo " |_____/ \___|_|_|\__, |_____/|_|\__, |_|\__\__,_|_|_____/|_|\_\_|_|_|___/"
echo "                    __/ |          __/ |                                   "
echo "                   |___/          |___/                                    "
echo -e "${RESET}"
banner TunnelBroker
echo -e "${RED}"
echo "-----------------------------------------------------------------------------"
echo "---------------------------- Set Your IPV6 with TunnelBroker ----------------"
echo "------------------------ Youtube : @DailyDigitalSkills ----------------------"
echo "--------------------------- You Can Use dds-ipv6  ----------------------------"
echo "-----------------------------------------------------------------------------"
echo -e "${RESET}"

# Display menu and prompt user for input
echo -e "${CYAN}1. Add New Ipv6 ! ${RESET}"
echo "                                                "
echo "${YELLOW}2. Show System IP Addresses${RESET}"
echo "                                                "
echo "${MAGENTA}3. Show Routing Table${RESET}"
echo "                                                "
echo "${GREEN}4. Check TunnelBroker Status${RESET}"
echo "                                                "
echo "${BLUE}5. Delete TunnelBroker${RESET}"
echo "                                                "
echo "${RED}6. Unistall${RESET}"
echo "                                                "
echo "${RED}7. Exit${RESET}"
echo "                                                "
}

process_choice() {
echo "                                                "
read -p "${GREEN}Please select an option: ${RESET}" choice

case $choice in
    1)
        read -p "${BLUE}Enter Tunnel ID (e.g. 2436): ${RESET}" ID
        read -p "${BLUE}Enter Tunnel Broker Server IP Address (190.80.70.60): ${RESET}" S_IP
        read -p "${BLUE}Enter Your Server IP Address (130.80.70.60): ${RESET}" L_IP
        read -p "${BLUE}Enter Your Tunnel Type (GRE, sit, wiregard; Default is sit): ${RESET}" Tunnel_Type
        read -p "${BLUE}Enter Client IPv6 Address (e.g. 2001:470:1f10:e1f::2): ${RESET}" C_IPv6
        read -p "${BLUE}Enter Server IPv6 Address (e.g. 2001:470:1f10:e1f::1): ${RESET}" S_IPv6

        sudo ip tunnel add TUNNEL-$ID mode $Tunnel_Type remote $L_IP local $S_IP ttl 255
        sudo ip link set TUNNEL-$ID up
        sudo ip -6 addr add $C_IPv6 dev TUNNEL-$ID
        # ایجاد یا به‌روزرسانی فایل /etc/network/interfaces
        CONFIG="iface eth0 inet6 static\naccept_ra 0\naddress $C_IPv6\nnetmask 64\ngateway $S_IPv6\nnameserver 8.8.8.8"

        if [ -f /etc/network/interfaces ]; then
            echo -e "\n# Config for TUNNEL-$ID\n$CONFIG" | sudo tee -a /etc/network/interfaces > /dev/null
        else
            echo -e "# Interfaces configuration\n\n$CONFIG" | sudo tee /etc/network/interfaces > /dev/null
        fi
        echo "                                                "
        echo "                                                "
        echo "${RED} Done ! Your Tunnel is Established & Your IPV6 Is : $C_IPv6${RESET}"
        echo "                                                "
        echo "                                                "
        echo "                                                "
        echo "                                                "
        read -p "In order for all settings to be applied, your virtual server needs to be rebooted. Reboot now? (Yes/No) (${GREEN}yes${RESET}/${RED}nn${RESET}): " answer_reboot
        if [ "$answer_reboot" == "yes" ]; then
        sudo reboot
        else
        echo "OK . Whenever needed, use the ${GREEN}reboot${RESET} command for this."
        echo "                                                "
        echo "                                                "
        echo "                                                "
        fi

        ;;
    2)
        echo -e "${CYAN}Showing System IP Addresses:${RESET}"
        echo "                                                "
        echo "                                                "
        echo "                                                "
        echo -e "${CYAN} IPv4 Addresses:${RESET}"
        echo "                                                "
        echo "-----------------------------------------------------------------"
        ip -4 addr show
        echo "                                                "
        echo "                                                "
        echo -e "${CYAN} IPv6 Addresses:${RESET}"
        echo "                                                "
        echo "-----------------------------------------------------------------"
        ip -6 addr show
        ;;
    
    3)
        echo -e "${MAGENTA}Showing Routing Table:${RESET}"
        echo "                                                "
        echo "                                                "
        echo "                                                "
        echo -e "${CYAN} IPv4 Routing Table:${RESET}"
        echo "                                                "
        echo "                                                "
        echo "-----------------------------------------------------------------"
        ip route show
        echo "                                                "
        echo -e "${CYAN} IPv6 Routing Table:${RESET}"
        echo "                                                "
        echo "                                                "
        echo "-----------------------------------------------------------------"
        ip -6 route show
        ;;
    
    4)
        read -p "${GREEN}Enter Tunnel ID to check status: ${RESET}" check_id
        echo -e "${CYAN}Checking status for TUNNEL-$check_id:${RESET}"
        ip link show TUNNEL-$check_id
        ;;
    
    5)
        read -p "${BLUE}Enter Tunnel ID to delete: ${RESET}" del_id
        echo -e "${RED}Deleting TUNNEL-$del_id from system and configuration...${RESET}"
        sudo ip tunnel del TUNNEL-$del_id
        TEMP_FILE=$(mktemp)
        trap "rm -f $TEMP_FILE" EXIT
        sed "/# Config for TUNNEL-$del_id/,/^$/d" /etc/network/interfaces > "$TEMP_FILE"
        sudo mv "$TEMP_FILE" /etc/network/interfaces
        echo "TUNNEL-$del_id has been deleted from system and configuration."
        ;;
    6)
    read -p "Are You Sure to Unistall DDS-IPv6? (${GREEN}yes${RESET}/${RED}no${RESET}): " answer
    if [ "$answer" == "yes" ]; then
    # اگر جواب yes بود، دستورات مورد نظر را اجرا کن
    echo "Oh ! Ok , No problem!"
    sudo unlink /usr/local/bin/dds-ipv6
    sudo rm -rf /root/dds-ipv6/
    exit 0
    # اینجا دستورات مورد نظر را قرار دهید
    else

    echo "OK"
    fi
            ;; 
    7)
        echo -e "${CYAN}Exiting...${RESET}"
        exit 0
        ;;    
    
    *)
        echo -e "${RED}Invalid option${RESET}"
        ;;
esac
}

while true; do
    show_menu
    process_choice
    
    # سوال برای بازگشت به منوی اصلی
    echo "                                                "
    read -p "${CYAN}Return to main menu? ${RESET}(${GREEN}y${RESET}/${RED}n${RESET}): " answer
    case $answer in
        [Yy]* )
            ;;
        [Nn]* )
            echo -e "${CYAN}Goodbye!${RESET}"
            exit 0
            ;;
        * )
            echo "Please answer yes or no."
            ;;
    esac
done