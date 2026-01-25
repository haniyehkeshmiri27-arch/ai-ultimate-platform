#!/bin/bash
# 🔍 اسکریپت تست شبکه برای ایران
# این اسکریپت را روی سیستم خودتان اجرا کنید

echo "========================================"
echo "🔍 تست کامل شبکه و اینترنت"
echo "========================================"
echo ""

# IP و کشور
echo "📍 === اطلاعات IP ==="
curl -s ifconfig.me 2>/dev/null || curl -s icanhazip.com 2>/dev/null
echo ""
curl -s ipinfo.io 2>/dev/null | head -10
echo ""

# DNS
echo "🌐 === تنظیمات DNS ==="
cat /etc/resolv.conf 2>/dev/null || echo "Cannot read DNS config"
echo ""

# تست سایت‌های فیلتر شده
echo "🚫 === تست سایت‌های معمولاً فیلتر شده ==="
sites=("google.com" "youtube.com" "twitter.com" "telegram.org" "facebook.com" "instagram.com" "whatsapp.com" "github.com" "pornhub.com")
for site in "${sites[@]}"; do
    result=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "https://$site" 2>/dev/null)
    if [ "$result" = "000" ]; then
        echo "❌ $site: BLOCKED/TIMEOUT"
    elif [ "$result" = "301" ] || [ "$result" = "302" ] || [ "$result" = "200" ]; then
        echo "✅ $site: OPEN ($result)"
    else
        echo "⚠️ $site: $result"
    fi
done
echo ""

# تست پورت‌ها
echo "🔌 === تست پورت‌های خروجی ==="
ports=(22 80 443 8080 1080 1194 51820 4500 500)
port_names=("SSH" "HTTP" "HTTPS" "Alt-HTTP" "SOCKS" "OpenVPN" "WireGuard" "IPSec-NAT" "IPSec")
for i in "${!ports[@]}"; do
    port=${ports[$i]}
    name=${port_names[$i]}
    timeout 3 bash -c "echo >/dev/tcp/8.8.8.8/$port" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Port $port ($name): OPEN"
    else
        echo "❌ Port $port ($name): BLOCKED"
    fi
done
echo ""

# تست پروتکل‌ها
echo "📡 === تست پروتکل‌ها ==="

# ICMP (Ping)
ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ ICMP (Ping): WORKS"
else
    echo "❌ ICMP (Ping): BLOCKED"
fi

# UDP
timeout 3 bash -c 'echo "test" > /dev/udp/8.8.8.8/53' 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ UDP: WORKS"
else
    echo "⚠️ UDP: May be limited"
fi

# DNS Resolution
nslookup google.com >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ DNS Resolution: WORKS"
else
    echo "❌ DNS Resolution: FAILED"
fi
echo ""

# تست DNS های معروف
echo "🔗 === تست DNS Servers ==="
dns_servers=("8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1" "9.9.9.9" "208.67.222.222")
dns_names=("Google-1" "Google-2" "Cloudflare-1" "Cloudflare-2" "Quad9" "OpenDNS")
for i in "${!dns_servers[@]}"; do
    dns=${dns_servers[$i]}
    name=${dns_names[$i]}
    timeout 3 nslookup google.com $dns >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ $name ($dns): WORKS"
    else
        echo "❌ $name ($dns): BLOCKED"
    fi
done
echo ""

# تست سرعت
echo "⚡ === تست سرعت ==="
speed=$(curl -s -o /dev/null -w "%{speed_download}" --connect-timeout 10 https://speed.cloudflare.com/__down?bytes=1000000 2>/dev/null)
if [ ! -z "$speed" ] && [ "$speed" != "0.000" ]; then
    speed_mb=$(echo "scale=2; $speed / 1048576" | bc 2>/dev/null || echo "N/A")
    echo "📥 Download Speed: ~${speed_mb} MB/s"
else
    echo "❌ Speed test failed"
fi
echo ""

# Traceroute
echo "🗺️ === مسیر اتصال (اولین 10 hop) ==="
traceroute -m 10 8.8.8.8 2>/dev/null || tracepath -m 10 8.8.8.8 2>/dev/null || echo "Traceroute not available"
echo ""

echo "========================================"
echo "✅ تست کامل شد!"
echo "========================================"
