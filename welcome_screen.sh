#!/bin/bash

# =========================================================
# 1. HEADER & INFO
# =========================================================
clear
if command -v lolcat > /dev/null; then
    figlet -f slant "EX Server" | lolcat
    echo "==========================================================================" | lolcat
else
    figlet -f slant "EX Server"
    echo "=========================================================================="
fi

neowofetch --ascii_distro debian --ascii --backend ascii
echo ""

# =========================================================
# 2. CALENDAR
# =========================================================
echo -e "\033[1;35m>> CALENDAR ($(date +'%B %Y')) 🗓️\033[0m"
cal | head -n 8
echo ""

# =========================================================
# 3. SYSTEM HEALTH & ALERTS (ส่วนใหม่! 🚨)
# =========================================================
echo -e "\033[1;31m>> SYSTEM ALERTS (Recent Errors) 🚨\033[0m"

# เช็ค Service ที่พัง (Failed Services)
FAILED_SERVICES=$(systemctl --failed --no-legend)
if [ -n "$FAILED_SERVICES" ]; then
    echo -e "  \033[0;31m[CRITICAL] Found failed services:\033[0m"
    systemctl --failed --no-legend | sed 's/^/  - /'
else
    echo -e "  \033[0;32m✓ No failed system services.\033[0m"
fi

# เช็ค Error Log 10 บรรทัดล่าสุด (จาก Journalctl)
# -p 3 หมายถึงเอาเฉพาะระดับ Error ขึ้นไป (3=Error, 2=Crit, 1=Alert)
# -xb หมายถึงเอาเฉพาะตั้งแต่เปิดเครื่องรอบนี้ (Current Boot)
LOG_ERRORS=$(journalctl -p 3 -xb --no-pager | tail -n 5)

if [ -n "$LOG_ERRORS" ]; then
    echo -e "\n  \033[0;33m[LOGS] Last 5 System Errors:\033[0m"
    echo "$LOG_ERRORS" | sed 's/^/  /' 
else
    echo -e "  \033[0;32m✓ System logs are clean (No critical errors).\033[0m"
fi
echo ""

# =========================================================
# 4. STORAGE & NETWORK
# =========================================================
echo -e "\033[1;36m>> STORAGE & NETWORK 💾\033[0m"
duf --only local --hide-fs tmpfs
echo ""
echo -e "Traffic (Default Gateway):"
vnstat -i $(ip route | grep default | awk '{print $5}') --style 3 | head -n 5

# =========================================================
# 5. PI-HOLE STATUS
# =========================================================
PIHOLE_API="http://localhost/admin/api.php"
echo -e "\n\033[1;32m>> PI-HOLE STATUS 🛡️\033[0m"
PI_STATS=$(curl -s --max-time 2 "$PIHOLE_API")

if [ -n "$PI_STATS" ]; then
    ADS_BLOCKED=$(echo "$PI_STATS" | jq -r '.ads_blocked_today' | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
    ADS_PERCENT=$(echo "$PI_STATS" | jq -r '.ads_percentage_today' | awk '{printf "%.2f%%", $1}')
    
    echo "  🚫 Ads Blocked Today:  $ADS_BLOCKED ($ADS_PERCENT)"
else
    echo "  ⚠️  Could not connect to Pi-hole API"
fi

# =========================================================
# 6. FOOTER
# =========================================================
echo -e "\n\033[1;33m>> WEATHER AT RAYONG ☀️\033[0m"
curl -s "wttr.in/Rayong?format=3"

echo ""
echo "=========================================================================="
echo -e "Welcome back, \033[1;35mUdon-san\033[0m. System checked."
echo ""
