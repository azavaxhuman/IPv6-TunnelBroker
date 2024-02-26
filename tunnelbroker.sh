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
echo -e "${CYAN}  1. Add New Ipv6 ! ${RESET}"
echo "                                                "
echo "${YELLOW}  2. Show System IP Addresses${RESET}"
echo "                                                "
echo "${MAGENTA}  3. Show Routing Table${RESET}"
echo "                                                "
echo "${BLUE}  4. Delete TunnelBroker${RESET}"
echo "                                                "
echo "${RED}  5. Unistall${RESET}"
echo "                                                "
echo "${RED}  6. Exit${RESET}"
echo "                                                "
}




process_choice() {
echo "                                                "
read -r -p "${GREEN}Please select an option: ${RESET}" choice

case $choice in
    1)
    read -r -p "${BLUE}Enter Tunnel Broker IPv4 Address (190.80.70.60): ${RESET}" S_IP
    read -r -p "${BLUE}Enter Tunnel Broker IPv6 Address (e.g. 2001:470:1f10:e1f::1): ${RESET}" S_IPv6_with_perfix
    S_IPv6="${S_IPv6_with_perfix%%/*}"
    C_IPv6=$(echo "$S_IPv6" | awk -F: '{$NF = $NF + 1;} 1' OFS=:)
    read -r -p "${BLUE}Enter Your Server IP Address (130.80.70.60): ${RESET}" C_IP

    netplan_version=$(dpkg -s netplan.io | grep Version | awk '{print $NF}')

        if [[ "${netplan_version%%-*}" > "0.103" ]]; then
network_config="
network:
  version: 2
  tunnels:
    he-ipv6:
      mode: sit
      remote: ${S_IP}
      local: ${C_IP}
      addresses:
        - \"${C_IPv6}/64\"
      routes:
        - to: default
          via: \"${S_IPv6}\""


        echo "$network_config" | sudo tee /etc/netplan/999dds-tunnel.yaml > /dev/null
        sudo netplan apply
        echo "${YELLOW}Netplan version is greater than or equal to${RESET}${GREEN} 0.103${RESET} "
        else
network_config="
network:
  version: 2
  tunnels:
    he-ipv6:
      mode: sit
      remote: ${S_IP}
      local: ${C_IP}
      addresses:
        - \"${C_IPv6}/64\"
      gateway6: ${S_IPv6}"

        echo "$network_config" | sudo tee /etc/netplan/999dds-tunnel.yaml > /dev/null
        sudo netplan apply
        echo "${YELLOW}Netplan version is less than${RESET}${GREEN} 0.103${RESET}"
        fi

        echo "                                                "
        echo "                                                "
        echo "${YELLOW} Done ! Your Tunnel is Established & Your IPV6 Is :${RESET}${GREEN} ${C_IPv6}${RESET}"
        echo "                                                "
        echo "                                                "
        echo "                                                "
        echo "                                                "
        read -r -p "In order for all settings to be applied, your virtual server needs to be rebooted.${YELLOW} Reboot now?${RESET} (Yes/No) (${GREEN}yes${RESET}/${RED}no${RESET}): " answer_reboot
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
        read -r -p "Are You Sure to delete Ipv6? (${GREEN}yes${RESET}/${RED}no${RESET}): " answer_rm
    if [ "$answer_rm" == "yes" ]; then
    # اگر جواب yes بود، دستورات مورد نظر را اجرا کن
    echo "Oh ! Ok , No problem!"
    sudo rm /etc/netplan/999dds-tunnel.yaml
    read -r -p "In order for all settings to be applied, your virtual server needs to be rebooted. Reboot now? (Yes/No) (${GREEN}yes${RESET}/${RED}no${RESET}): " answer_reboot_del
        if [ "$answer_reboot_del" == "yes" ]; then
        sudo reboot
        else
        echo "OK . Whenever needed, use the ${GREEN}reboot${RESET} command for this."
        echo ""
        fi
    # اینجا دستورات مورد نظر را قرار دهید
    else
    echo "OK"
    fi
        ;;
    5)
    read -r -p "Are You Sure to Unistall DDS-IPv6? (${GREEN}yes${RESET}/${RED}no${RESET}): " answer
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
    6)
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
    read -r -p "${CYAN}Return to main menu? ${RESET}(${GREEN}y${RESET}/${RED}n${RESET}): " answer
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