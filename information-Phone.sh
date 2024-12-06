#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

API_KEY="a79531fd472a9e27945e2eeeafdd95ac"

print_banner() {
    echo -e "${CYAN}"
    echo "############################################"
    echo "#                                          #"
    echo "#    ██████╗  ███████╗                  #"
    echo "#    ██╔══██  ██╔════╝                  #"
    echo "#    ██║  ██║ █████╗                     #"
    echo "#    ██   ██║ ██                          #"
    echo "#    ██████╔  ██                         #"
    echo "#   ╚══════╝ ╚═╝                         #"
    echo "#                                          #"
    echo "#               GBS DF - PHONE INFO TOOL   #"
    echo "#                Designed by @A_Y_TR       #"
    echo "#############################################"
    echo -e "${NC}"
}

check_dependencies() {
    echo -e "${YELLOW}⚙️ Checking dependencies...${NC}"
    if ! command -v curl &>/dev/null; then
        echo -e "${RED}❌ curl is not installed. Installing...${NC}"
        sudo apt update && sudo apt install -y curl || pkg install curl -y
    fi
    echo -e "${GREEN}✅ All dependencies are installed!${NC}"
}

parse_json() {
    echo "$1" | grep -o "\"$2\":\"[^\"]*" | sed -E "s/\"$2\":\"//"
}

fetch_phone_details() {
    local phone_number="$1"
    echo -e "${CYAN}🔍 Fetching details for phone number: ${WHITE}${phone_number}${NC}"

    phone_response=$(curl -s "https://api.apilayer.com/number_verification/validate?access_key=${API_KEY}&number=${phone_number}")
    ip_response=$(curl -s "http://ip-api.com/json/")

    if [[ -z "$phone_response" || "$phone_response" == *"error"* ]]; then
        echo -e "${RED}❌ Failed to fetch details. Check the phone number or API key.${NC}"
        exit 1
    fi

    # Parse phone details
    valid=$(parse_json "$phone_response" "valid")
    country=$(parse_json "$phone_response" "country_name")
    country_code=$(parse_json "$phone_response" "country_code")
    location=$(parse_json "$phone_response" "location")
    carrier=$(parse_json "$phone_response" "carrier")
    line_type=$(parse_json "$phone_response" "line_type")

    # Parse IP details
    ip=$(parse_json "$ip_response" "query")
    lat=$(parse_json "$ip_response" "lat")
    lon=$(parse_json "$ip_response" "lon")
    region=$(parse_json "$ip_response" "regionName")
    city=$(parse_json "$ip_response" "city")
    timezone=$(parse_json "$ip_response" "timezone")
    isp=$(parse_json "$ip_response" "isp")

    echo -e "${GREEN}================================================${NC}"
    echo -e "${CYAN}📞 Phone Number Details:${NC}"
    echo -e "${WHITE}Valid: ${GREEN}$valid${NC}"
    echo -e "${WHITE}Country: ${GREEN}$country${NC}"
    echo -e "${WHITE}Country Code: ${GREEN}$country_code${NC}"
    echo -e "${WHITE}Location: ${GREEN}$location${NC}"
    echo -e "${WHITE}Carrier: ${GREEN}$carrier${NC}"
    echo -e "${WHITE}Line Type: ${GREEN}$line_type${NC}"

    echo -e "${CYAN}================================================${NC}"
    echo -e "${CYAN}🌍 Location Details:${NC}"
    echo -e "${WHITE}IP Address: ${GREEN}$ip${NC}"
    echo -e "${WHITE}Region: ${GREEN}$region${NC}"
    echo -e "${WHITE}City: ${GREEN}$city${NC}"
    echo -e "${WHITE}Latitude: ${GREEN}$lat${NC}"
    echo -e "${WHITE}Longitude: ${GREEN}$lon${NC}"
    echo -e "${WHITE}Timezone: ${GREEN}$timezone${NC}"
    echo -e "${WHITE}ISP: ${GREEN}$isp${NC}"

    echo -e "${CYAN}================================================${NC}"
    if [[ "$lat" != "null" && "$lon" != "null" ]]; then
        echo -e "${YELLOW}📍 View Address: https://www.google.com/maps/search/?api=1&query=${lat},${lon}${NC}"
    else
        echo -e "${RED}❌ Unable to determine precise location.${NC}"
    fi
    echo -e "${GREEN}================================================${NC}"
}

main() {
    print_banner
    check_dependencies
    echo -e -n "${CYAN}📱 Enter the phone number (with country code): ${NC}"
    read phone_number
    fetch_phone_details "$phone_number"
}

main
