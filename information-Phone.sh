#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

print_banner() {
    echo -e "${CYAN}##############################################"
    echo -e "${CYAN}#               SCAN PHONE TOOL              #"
    echo -e "${CYAN}##############################################"
    echo -e "${YELLOW}#         Designed by @A_Y_TR 🚀             #"
    echo -e "${CYAN}##############################################${NC}"
}

check_dependencies() {
    echo -e "${GREEN}Checking dependencies...${NC}"
    if ! command -v curl &>/dev/null; then
        echo -e "${RED}curl is not installed. Installing...${NC}"
        sudo apt update && sudo apt install -y curl
    fi
    if ! command -v jq &>/dev/null; then
        echo -e "${RED}jq is not installed. Installing...${NC}"
        sudo apt update && sudo apt install -y jq
    fi
}

fetch_phone_details() {
    local phone_number="$1"
    echo -e "${CYAN}🔍 Fetching details for phone number: ${phone_number}${NC}"

    response=$(curl -s "https://api.apilayer.com/number_verification/validate?access_key=a79531fd472a9e27945e2eeeafdd95ac&number=${phone_number}")

    if [[ -z "$response" || "$response" == *"error"* ]]; then
        echo -e "${RED}❌ Failed to fetch details. Please check the phone number or API.${NC}"
        exit 1
    fi

    country=$(echo "$response" | jq -r '.country_name')
    country_code=$(echo "$response" | jq -r '.country_code')
    location=$(echo "$response" | jq -r '.location')
    carrier=$(echo "$response" | jq -r '.carrier')
    line_type=$(echo "$response" | jq -r '.line_type')
    valid=$(echo "$response" | jq -r '.valid')

    geo_response=$(curl -s "http://ip-api.com/json/${phone_number}")
    lat=$(echo "$geo_response" | jq -r '.lat')
    lon=$(echo "$geo_response" | jq -r '.lon')
    region=$(echo "$geo_response" | jq -r '.regionName')
    city=$(echo "$geo_response" | jq -r '.city')
    timezone=$(echo "$geo_response" | jq -r '.timezone')
    isp=$(echo "$geo_response" | jq -r '.isp')

    echo -e "${GREEN}📋 Phone Details:${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    printf "${YELLOW}%-15s %-20s${NC}\n" "Field" "Value"
    echo -e "${CYAN}-----------------------------------------${NC}"
    printf "${GREEN}%-15s %-20s${NC}\n" "Valid:" "$valid"
    printf "${GREEN}%-15s %-20s${NC}\n" "Country:" "$country"
    printf "${GREEN}%-15s %-20s${NC}\n" "Country Code:" "$country_code"
    printf "${GREEN}%-15s %-20s${NC}\n" "Location:" "$location"
    printf "${GREEN}%-15s %-20s${NC}\n" "Carrier:" "$carrier"
    printf "${GREEN}%-15s %-20s${NC}\n" "Line Type:" "$line_type"
    printf "${GREEN}%-15s %-20s${NC}\n" "Region:" "$region"
    printf "${GREEN}%-15s %-20s${NC}\n" "City:" "$city"
    printf "${GREEN}%-15s %-20s${NC}\n" "Latitude:" "$lat"
    printf "${GREEN}%-15s %-20s${NC}\n" "Longitude:" "$lon"
    printf "${GREEN}%-15s %-20s${NC}\n" "Timezone:" "$timezone"
    printf "${GREEN}%-15s %-20s${NC}\n" "ISP:" "$isp"
    echo -e "${CYAN}-----------------------------------------${NC}"

    if [[ "$lat" != "null" && "$lon" != "null" ]]; then
        echo -e "${YELLOW}🌍 View on Google Maps: https://www.google.com/maps/@${lat},${lon},12z${NC}"
    else
        echo -e "${RED}❌ Unable to determine location.${NC}"
    fi
}

main() {
    print_banner
    check_dependencies
    read -p "$(echo -e ${CYAN}Enter the phone number (with country code): ${NC})" phone_number
    fetch_phone_details "$phone_number"
}

main
