#!/bin/bash

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 

clear

echo -e "${CYAN}"
echo "#######################################"
echo "#                                     #"
echo "#    ██████╗  ███████╗             #"
echo "#    ██╔══██  ██╔════╝             #"
echo "#    ██║  ██║ █████╗               #"
echo "#    ██   ██║ ██                   #"
echo "#    ██████╔  ██                   #"
echo "#   ╚══════╝ ╚═╝                    #"
echo "#                                     #"
echo "#         GBS DF - PHONE INFO TOOL    #"
echo "#           Designed by @A_Y_TR       #"
echo "#######################################"
echo -e "${NC}"

read -p "$(echo -e ${CYAN}Enter the phone number (with country code): ${NC})" phone_number

response=$(curl -s "https://api.apilayer.com/number_lookup/validate?number=${phone_number}" -H "apikey: a79531fd472a9e27945e2eeeafdd95ac")

valid=$(echo $response | jq -r '.valid')
country=$(echo $response | jq -r '.country_name')
country_code=$(echo $response | jq -r '.country_prefix')
location=$(echo $response | jq -r '.location')
carrier=$(echo $response | jq -r '.carrier')
line_type=$(echo $response | jq -r '.line_type')
checked_at=$(date +"%Y-%m-%d %H:%M:%S")

if [[ "$valid" == "true" ]]; then
    echo -e "${GREEN}📞 Phone Number Details:${NC}"
    echo -e "${CYAN}Valid:${NC} ${GREEN}Yes${NC}"
    echo -e "${CYAN}Country:${NC} ${GREEN}$country${NC}"
    echo -e "${CYAN}Country Code:${NC} ${GREEN}$country_code${NC}"
    echo -e "${CYAN}Location:${NC} ${GREEN}$location${NC}"
    echo -e "${CYAN}Carrier:${NC} ${GREEN}$carrier${NC}"
    echo -e "${CYAN}Line Type:${NC} ${GREEN}$line_type${NC}"
    echo -e "${CYAN}Checked At:${NC} ${GREEN}$checked_at${NC}"

    ip=$(curl -s "https://api.apilayer.com/ip_to_location/ip?ip=auto" -H "apikey: a79531fd472a9e27945e2eeeafdd95ac")
    ip_address=$(echo $ip | jq -r '.ip')
    region=$(echo $ip | jq -r '.region')
    city=$(echo $ip | jq -r '.city')
    latitude=$(echo $ip | jq -r '.latitude')
    longitude=$(echo $ip | jq -r '.longitude')
    isp=$(echo $ip | jq -r '.isp')

    echo -e "${CYAN}🌍 Location Details:${NC}"
    echo -e "${CYAN}IP Address:${NC} ${GREEN}$ip_address${NC}"
    echo -e "${CYAN}Region:${NC} ${GREEN}$region${NC}"
    echo -e "${CYAN}City:${NC} ${GREEN}$city${NC}"
    echo -e "${CYAN}Latitude:${NC} ${GREEN}$latitude${NC}"
    echo -e "${CYAN}Longitude:${NC} ${GREEN}$longitude${NC}"
    echo -e "${CYAN}ISP:${NC} ${GREEN}$isp${NC}"

    echo -e "${CYAN}📍 View Location:${NC} ${GREEN}https://www.google.com/maps/search/?api=1&query=$latitude,$longitude${NC}"

    read -p "$(echo -e ${CYAN}Would you like to search this number on Truecaller? (y/n): ${NC})" search_truecaller

    if [[ "$search_truecaller" == "y" || "$search_truecaller" == "Y" ]]; then
        echo -e "${CYAN}🔗 Open Truecaller Search:${NC} ${GREEN}https://www.truecaller.com/search/global/$phone_number${NC}"
    fi

    read -p "$(echo -e ${CYAN}Would you like to search this number on social media platforms? (y/n): ${NC})" search_social

    if [[ "$search_social" == "y" || "$search_social" == "Y" ]]; then
        echo -e "${CYAN}🔍 Searching on TikTok:${NC} ${GREEN}https://www.tiktok.com/@$phone_number${NC}"
        echo -e "${CYAN}🔍 Searching on WhatsApp:${NC} ${GREEN}https://wa.me/$phone_number${NC}"
        echo -e "${CYAN}🔍 Searching on Facebook:${NC} ${GREEN}https://www.facebook.com/search/top?q=$phone_number${NC}"
    fi
else
    echo -e "${RED}Invalid phone number! Please try again.${NC}"
fi

echo -e "${CYAN}Thank you for using the GBS DF - Phone Info Tool!${NC}"
echo -e "${CYAN}User Developer: @A_Y_TR${NC}"
