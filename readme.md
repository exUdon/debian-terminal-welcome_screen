# 🚀 EX Server Welcome Screen

A maximalist, data-rich terminal welcome screen for Debian Servers.
Designed for sysadmins who love to see everything at a glance upon login.

![Screenshot](screenshot.png)
*(Place your screenshot here)*

## ✨ Features

- **Banner:** Cool ASCII header with gradient colors (`figlet` + `lolcat`).
- **System Info:** Hardware and OS details using `neowofetch`.
- **Calendar:** Current month view (`ncal`).
- **System Alerts:** 🚨 Displays failed system services and recent critical errors from `journalctl`.
- **Storage:** Visual disk usage bars using `duf`.
- **Network:** Daily traffic monitoring using `vnstat`.
- **Pi-hole Stats:** 🛡️ Real-time ads blocked, DNS queries, and percentage (via API).
- **Weather:** Current weather forecast for your location (`wttr.in`).

## 🛠️ Prerequisites

You need to install the following packages on your Debian/Ubuntu server:

```bash
sudo apt update
sudo apt install figlet lolcat neowofetch duf vnstat jq curl ncal
```
Note for system logs: To allow the script to read system logs without sudo, add your user to the systemd-journal group:
```bash
sudo usermod -aG systemd-journal $USER
```
(Please logout and login again for this to take effect).

## 🛠️ Prerequisites
1.Clone the repository:
```bash
git clone [https://github.com/exUdon/welcome-screen.git](https://github.com/exUdon/welcome-screen.git)
cd welcome-screen
```
2.Make the script executable:
```bash
chmod +x welcome-screen.git
```
3.Run it:
```bash
./welcome_screen.sh
```

## ⚙️ Configuration
Open welcome_screen.sh to customize:
  - Pi-hole API:
    PIHOLE_API="http://localhost/admin/api.php"
  - Weather location:
    curl -s "wttr.in/Bangkok?format=3"
  - Network Interface:
    The script automatically detects the default gateway interface. If you want to specific one, edit the vnstat command line.

## 🚀 Auto-Start on Login
To see this screen every time you SSH into your server, add this line to your .zshrc or .bashrc:
```
# inside ~/.zshrc
source ~/path/to/welcome-screen.sh
```

## 👤 Author
Teacher Udon
  - Powered by EX Server & Gemini.AI 🤖
