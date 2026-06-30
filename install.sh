#!/bin/bash

# رنگ‌ها برای منو
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
CYAN='\033[0;36m'

clear
echo -e "${CYAN}=====================================${NC}"
echo -e "${GREEN}    اسکریپت اختصاصی مدیریت لوکیشن تور   ${NC}"
echo -e "${CYAN}=====================================${NC}"

# ۱. نصب پیش‌نیازها در صورت عدم وجود
if ! command -v tor &> /dev/null; then
    echo -e "${CYAN}[*] در حال نصب تور...${NC}"
    sudo apt update && sudo apt install tor -y
fi

# ۲. منوی انتخاب لوکیشن
echo -e "\n${GREEN}لوکیشن مورد نظر خود را انتخاب کنید:${NC}"
echo -e "1) ترکیه (TR)"
echo -e "2) آلمان (DE)"
echo -e "3) فرانسه (FR)"
echo -e "4) بریتانیا (GB)"
echo -e "5) هلند (NL)"
echo -e "6) آمریکا (US)"
echo -e "7) ورود کد کشور به صورت دستی (مثلاً az)"
read -p "عدد گزینه را وارد کنید: " choice

case $choice in
    1) country="TR" ;;
    2) country="DE" ;;
    3) country="FR" ;;
    4) country="GB" ;;
    5) country="NL" ;;
    6) country="US" ;;
    7) 
        read -p "کد دو حرفی کشور را وارد کنید (حروف کوچک یا بزرگ): " manual_country
        country=$(echo "$manual_country" | tr '[:lower:]' '[:upper:]')
        ;;
    *) 
        echo -e "${RED}گزینه نامعتبر! خروج...${NC}"
        exit 1
        ;;
esac

read -p "پورت ساکس دلخواه را وارد کنید (پیش‌فرض 3080): " port
port=${port:-3080}

# ۳. اعمال تنظیمات روی فایل torrc
echo -e "${CYAN}[*] در حال تنظیم کانفیگ تور روی کشور ${country} و پورت ${port}...${NC}"

cat << ENF | sudo tee /etc/tor/torrc
SocksPort 127.0.0.1:$port
ExitNodes {$country}
StrictNodes 1
ENF

# ۴. راه‌اندازی مجدد و پاکسازی کش تور
echo -e "${CYAN}[*] در حال ریستارت و پاکسازی کش تور...${NC}"
sudo systemctl stop tor
sudo rm -rf /var/lib/tor/*
sudo systemctl start tor

echo -e "${GREEN}[+] تور با موفقیت راه‌اندازی شد. ۵ ثانیه صبر کنید برای تست آی‌پی...${NC}"
sleep 5

# ۵. تست خروجی آی‌پی
echo -e "${CYAN}[*] خروجی تست آی‌پی:${NC}"
curl --socks5-hostname 127.0.0.1:$port https://ip2c.org/self

echo -e "\n${GREEN}=====================================${NC}"
echo -e "تنظیمات تمام شد! حالا در پنل X-UI ثنایی یک Outbound با مشخصات زیر بسازید:"
echo -e "پروتکل: ${GREEN}Socks${NC}"
echo -e "آی‌پی: ${GREEN}127.0.0.1${NC}"
echo -e "پورت: ${GREEN}$port${NC}"
echo -e "${GREEN}=====================================${NC}"
