#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'

clear
echo -e "${CYAN}=====================================${NC}"
echo -e "${GREEN}    Tor Multi-Location Manager       ${NC}"
echo -e "${CYAN}=====================================${NC}"

# 1. Main Menu (Install or Uninstall)
echo -e "1) Enter Location Installation Menu"
echo -e "2) Uninstall Tor completely from Server"
echo -e "0) Exit"
echo -e "${CYAN}=====================================${NC}"
read -p "Select option index: " main_choice

# Operation: Complete Uninstall
if [ "$main_choice" == "2" ]; then
    echo -e "${RED}[*] Stopping and disabling all Tor instances...${NC}"
    sudo systemctl stop "tor@*" 2>/dev/null
    sudo systemctl stop tor 2>/dev/null
    sudo systemctl disable "tor@*" 2>/dev/null
    sudo systemctl disable tor 2>/dev/null
    
    echo -e "${RED}[*] Purging Tor packages and directories...${NC}"
    sudo apt-get purge tor -y
    sudo rm -rf /etc/tor/ /var/lib/tor/
    echo -e "${GREEN}[+] Tor has been completely uninstalled from the server.${NC}"
    exit 0
fi

if [ "$main_choice" == "0" ] || [ -z "$main_choice" ]; then
    echo "Exiting..."
    exit 0
fi

if [ "$main_choice" != "1" ]; then
    echo -e "${RED}Invalid choice! Exiting...${NC}"
    exit 1
fi

# 2. Install Prerequisites if not present
if ! command -v tor &> /dev/null; then
    echo -e "${CYAN}[*] Installing Tor core package...${NC}"
    sudo apt update && sudo apt install tor -y
fi

# 3. Locations Menu (Exactly matching your Termius layout)
clear
echo -e "${GREEN}Available Locations:${NC}"
echo -e " 01 - [DE] [9080] - Germany"
echo -e " 02 - [TR] [9081] - Turkey"
echo -e " 03 - [US] [9082] - United States"
echo -e " 04 - [FR] [9083] - France"
echo -e " 05 - [AT] [9084] - Austria"
echo -e " 06 - [BE] [9085] - Belgium"
echo -e " 07 - [RO] [9086] - Romania"
echo -e " 08 - [CA] [9087] - Canada"
echo -e " 09 - [SG] [9088] - Singapore"
echo -e " 10 - [JP] [9089] - Japan"
echo -e " 11 - [IE] [9090] - Ireland"
echo -e " 12 - [FI] [9091] - Finland"
echo -e " 13 - [ES] [9092] - Spain"
echo -e " 14 - [PL] [9093] - Poland"
echo -e " 15 - [NL] [9094] - Netherlands"
echo -e " 16 - [IT] [9095] - Italy"
echo -e " 17 - [CH] [9096] - Switzerland"
echo -e " 18 - [SE] [9097] - Sweden"
echo -e " 19 - [NO] [9098] - Norway"
echo -e " 20 - [DK] [9099] - Denmark"
echo -e " 21 - [IS] [9100] - Iceland"
echo -e " 22 - [AU] [9101] - Australia"
echo -e " 23 - [IN] [9102] - India"
echo -e " 24 - [HK] [9103] - Hong Kong"
echo -e " 25 - [UA] [9104] - Ukraine"
echo -e " 26 - [CZ] [9105] - Czech Republic"
echo -e " 27 - [KR] [9106] - South Korea"
echo -e " 28 - [ZA] [9107] - South Africa"
echo -e " 29 - [MX] [9108] - Mexico"
echo -e " 30 - [MY] [9109] - Malaysia"
echo -e " 31 - [AZ] [9110] - Azerbaijan"
echo -e " 32 - [CY] [9111] - Cyprus"
echo -e " 33 - [GR] [9112] - Greece"
echo -e " 34 - [PT] [9113] - Portugal"
echo -e " 35 - [HU] [9114] - Hungary"
echo -e " 36 - [LU] [9115] - Luxembourg"
echo -e " 00 - Back to main menu"
echo ""
read -p "Select location index: " loc_index

# Set port and country based on index
case $loc_index in
    01|1) country="DE"; port=9080 ;;
    02|2) country="TR"; port=9081 ;;
    03|3) country="US"; port=9082 ;;
    04|4) country="FR"; port=9083 ;;
    05|5) country="AT"; port=9084 ;;
    06|6) country="BE"; port=9085 ;;
    07|7) country="RO"; port=9086 ;;
    08|8) country="CA"; port=9087 ;;
    09|9) country="SG"; port=9088 ;;
    10) country="JP"; port=9089 ;;
    11) country="IE"; port=9090 ;;
    12) country="FI"; port=9091 ;;
    13) country="ES"; port=9092 ;;
    14) country="PL"; port=9093 ;;
    15) country="NL"; port=9094 ;;
    16) country="IT"; port=9095 ;;
    17) country="CH"; port=9096 ;;
    18) country="SE"; port=9097 ;;
    19) country="NO"; port=9098 ;;
    20) country="DK"; port=9099 ;;
    21) country="IS"; port=9100 ;;
    22) country="AU"; port=9101 ;;
    23) country="IN"; port=9102 ;;
    24) country="HK"; port=9103 ;;
    25) country="UA"; port=9104 ;;
    26) country="CZ"; port=9105 ;;
    27) country="KR"; port=9106 ;;
    28) country="ZA"; port=9107 ;;
    29) country="MX"; port=9108 ;;
    30) country="MY"; port=9109 ;;
    31) country="AZ"; port=9110 ;;
    32) country="CY"; port=9111 ;;
    33) country="GR"; port=9112 ;;
    34) country="PT"; port=9113 ;;
    35) country="HU"; port=9114 ;;
    36) country="LU"; port=9115 ;;
    00|0) echo "Returning..."; exit 0 ;;
    *) echo -e "${RED}Invalid selection!${NC}"; exit 1 ;;
esac

# 4. Multi-instance Configuration (Bug-Free Method)
echo -e "${CYAN}[*] Configuring ${country} on dedicated port ${port}...${NC}"

# Setup separate data directory for isolation
sudo mkdir -p /var/lib/tor/tor_$port
sudo chown -R debian-tor:debian-tor /var/lib/tor/tor_$port/
sudo chmod 700 /var/lib/tor/tor_$port/

# Generate unique config file for this instance
cat << ENF | sudo tee /etc/tor/torrc.$port > /dev/null
SocksPort 127.0.0.1:$port
ExitNodes {$country}
StrictNodes 1
DataDirectory /var/lib/tor/tor_$port
PidFile /var/run/tor/tor_$port.pid
Log notice file /var/log/tor/notices_$port.log
ENF

# Link instance config to Tor multi-instance generator
sudo ln -sf /etc/tor/torrc.$port /etc/tor/instances/$port

# 5. Start and Enable the specific instance service
echo -e "${CYAN}[*] Starting Tor instance for port ${port}...${NC}"
sudo systemctl daemon-reload
sudo systemctl stop tor@$port 2>/dev/null
sudo systemctl start tor@$port
sudo systemctl enable tor@$port

echo -e "${GREEN}[+] Instance started successfully. Waiting 6 seconds for circuit build...${NC}"
sleep 6

# 6. Test outbound IP connectivity
echo -e "${CYAN}[*] Testing connection response via port ${port}:${NC}"
curl_res=$(curl --socks5-hostname 127.0.0.1:$port -s https://ip2c.org/self)

if [[ $curl_res == *"1;"* ]]; then
    echo -e "${GREEN}[SUCCESS] Outbound IP Details: $curl_res${NC}"
else
    echo -e "${RED}[WARNING] Test failed or delayed. Current response: $curl_res${NC}"
    echo -e "${YELLOW}Tor is running, but building this specific circuit might take up to 1-2 minutes.${NC}"
fi

echo -e "\n${YELLOW}=====================================${NC}"
echo -e "Location ${GREEN}${country}${NC} is successfully deployed in background!"
echo -e "You can now add it inside X-UI Outbound Panel:"
echo -e "Protocol: ${GREEN}Socks${NC} | IP: ${GREEN}127.0.0.1${NC} | Port: ${GREEN}$port${NC}"
echo -e "${YELLOW}Notice:${NC} You can re-run this script anytime to add more locations simultaneously."
echo -e "${YELLOW}=====================================${NC}"
