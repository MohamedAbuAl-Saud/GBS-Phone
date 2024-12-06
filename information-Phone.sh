#!/bin/bash

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

install_dependencies() {
    echo -e "${CYAN}Checking and installing required dependencies...${NC}"
    
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}curl is not installed. Installing curl...${NC}"
        if [ -x "$(command -v apt)" ]; then
            sudo apt update && sudo apt install -y curl
        elif [ -x "$(command -v pacman)" ]; then
            sudo pacman -S curl
        elif [ -x "$(command -v pkg)" ]; then
            pkg install curl
        else
            echo -e "${RED}Unsupported package manager. Please install curl manually.${NC}"
            exit 1
        fi
    fi
    
    if ! command -v sed &> /dev/null || ! command -v grep &> /dev/null; then
        echo -e "${RED}sed or grep is missing. Installing them...${NC}"
        if [ -x "$(command -v apt)" ]; then
            sudo apt update && sudo apt install -y sed grep
        elif [ -x "$(command -v pacman)" ]; then
            sudo pacman -S sed grep
        elif [ -x "$(command -v pkg)" ]; then
            pkg install sed grep
        else
            echo -e "${RED}Unsupported package manager. Please install sed and grep manually.${NC}"
            exit 1
        fi
    fi
}

install_dependencies

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

echo -e "${CYAN}Enter the phone number (with country code):${NC}"
read phone_number

response=$(curl -s "https://api.apilayer.com/number_lookup/validate?number=${phone_number}" -H "apikey: a79531fd472a9e27945e2eeeafdd95ac")

valid=$(echo "$response" | grep -o '"valid":[^,]*' | sed 's/"valid"://g' | tr -d '"')
country=$(echo "$response" | grep -o '"country_name":"[^"]*' | sed 's/"country_name":"//g' | tr -d '"')
country_code=$(echo "$response" | grep -o '"country_prefix":"[^"]*' | sed 's/"country_prefix":"//g' | tr -d '"')
location=$(echo "$response" | grep -o '"location":"[^"]*' | sed 's/"location":"//g' | tr -d '"')
carrier=$(echo "$response" | grep -o '"carrier":"[^"]*' | sed 's/"carrier":"//g' | tr -d '"')
line_type=$(echo "$response" | grep -o '"line_type":"[^"]*' | sed 's/"line_type":"//g' | tr -d '"')
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
    
    ip_address=$(echo "$ip" | grep -o '"ip":"[^"]*' | sed 's/"ip":"//g' | tr -d '"')
    region=$(echo "$ip" | grep -o '"region":"[^"]*' | sed 's/"region":"//g' | tr -d '"')
    city=$(echo "$ip" | grep -o '"city":"[^"]*' | sed 's/"city":"//g' | tr -d '"')
    latitude=$(echo "$ip" | grep -o '"latitude":[^,]*' | sed 's/"latitude"://g')
    longitude=$(echo "$ip" | grep -o '"longitude":[^,]*' | sed 's/"longitude"://g')
    isp=$(echo "$ip" | grep -o '"isp":"[^"]*' | sed 's/"isp":"//g' | tr -d '"')

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
