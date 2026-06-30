#!/bin/bash

# رنگ‌ها برای منو
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'

clear
echo -e "${CYAN}=====================================${NC}"
echo -e "${GREEN}    اسکریپت پیشرفته مدیریت چندلوکیشنی تور   ${NC}"
echo -e "${CYAN}=====================================${NC}"

# ۱. منوی اصلی (نصب یا حذف)
echo -e "1) ورود به منوی نصب و اضافه کردن لوکیشن"
echo -e "2) حذف کامل سرویس تور از سرور"
read -p "گزینه مورد نظر را انتخاب کنید: " main_choice

# عملیات حذف کامل
if [ "$main_choice" == "2" ]; then
    echo -e "${RED}[*] در حال حذف کامل تور و پاکسازی تنظیمات...${NC}"
    sudo systemctl stop tor
    sudo apt-get purge tor -y
    sudo rm -rf /etc/tor/ /var/lib/tor/
    echo -e "${GREEN}[+] تور با موفقیت کاملاً حذف شد.${NC}"
    exit 0
fi

if [ "$main_choice" != "1" ]; then
    echo -e "${RED}گزینه نامعتبر!${NC}"
    exit 1
fi

# ۲. نصب پیش‌نیازها در صورت عدم وجود
if ! command -v tor &> /dev/null; then
    echo -e "${CYAN}[*] در حال نصب تور...${NC}"
    sudo apt update && sudo apt install tor -y
fi

# ۳. منوی لوکیشن‌ها دقیقاً مثل شات ترمیوس شما
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

# ست کردن پورت و کشور بر اساس انتخاب
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
    00|0) echo "خروج..."; exit 0 ;;
    *) echo -e "${RED}انتخاب نامعتبر!${NC}"; exit 1 ;;
esac

# ۴. اضافه کردن کانفیگ بدون پاک کردن کانفیگ‌های قبلی
# برای اینکه لوکیشن‌ها کنار هم کار کنند، تنظیمات هر لوکیشن را در یک فایل مجزا در دایرکتوری تور می‌سازیم.
echo -e "${CYAN}[*] در حال کانفیگ لوکیشن ${country} روی پورت اختصاصی ${port}...${NC}"

# ایجاد پوشه دیتا اختصاصی برای هر پورت جهت جلوگیری از تداخل مدارها
sudo mkdir -p /var/lib/tor/tor_$port
sudo chown -R debian-tor:debian-tor /var/lib/tor/tor_$port/

cat << ENF | sudo tee /etc/tor/torrc.$port
SocksPort 127.0.0.1:$port
ExitNodes {$country}
StrictNodes 1
DataDirectory /var/lib/tor/tor_$port
ENF

# اضافه کردن این فایل به کانفیگ اصلی تور در صورت عدم وجود
if ! grep -q "torrc.$port" /etc/tor/torrc; then
    echo "%include /etc/tor/torrc.$port" | sudo tee -a /etc/tor/torrc
fi

# ۵. ریستارت سرویس تور برای اعمال پورت جدید
echo -e "${CYAN}[*] در حال ریستارت سرویس تور...${NC}"
sudo systemctl restart tor

echo -e "${GREEN}[+] لوکیشن با موفقیت فعال شد. ۵ ثانیه صبر کنید برای تست آی‌پی...${NC}"
sleep 5

# ۶. تست خروجی پورت ساخته شده
echo -e "${CYAN}[*] نتیجه تست آی‌پی روی پورت ${port}:${NC}"
curl --socks5-hostname 127.0.0.1:$port https://ip2c.org/self

echo -e "\n${YELLOW}=====================================${NC}"
echo -e "لوکیشن ${GREEN}${country}${NC} با موفقیت در پس‌زمینه فعال ماند!"
echo -e "حالا می‌توانید در پنل X-UI یک Outbound جدید بسازید:"
echo -e "پروتکل: ${GREEN}Socks${NC} | آی‌پـی: ${GREEN}127.0.0.1${NC} | پورت: ${GREEN}$port${NC}"
echo -e "${YELLOW}نکته:${NC} شما می‌توانید دوباره اسکریپت را ران کنید و لوکیشن‌های دیگر را هم بدون حذف شدن این لوکیشن اضافه کنید."
echo -e "${YELLOW}=====================================${NC}"
