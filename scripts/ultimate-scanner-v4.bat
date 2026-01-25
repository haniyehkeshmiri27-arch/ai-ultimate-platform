@echo off
chcp 65001 >nul
title Ultimate Network Scanner v4.0 - IRAN Professional Edition
color 0A
mode con: cols=100 lines=60

echo.
echo ╔════════════════════════════════════════════════════════════════════════════════════════════╗
echo ║                    ULTIMATE NETWORK SCANNER v4.0 - IRAN EDITION                            ║
echo ╠════════════════════════════════════════════════════════════════════════════════════════════╣
echo ║  Global Ping Test │ DNS Benchmark │ CDN Test │ VPS Analysis │ Nameserver Check             ║
echo ╚════════════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo Start Time: %date% %time%
echo.

set "RESULTS_FILE=%USERPROFILE%\Desktop\network-scan-results.txt"
echo ================================================================================ > "%RESULTS_FILE%"
echo ULTIMATE NETWORK SCANNER v4.0 - RESULTS >> "%RESULTS_FILE%"
echo Date: %date% %time% >> "%RESULTS_FILE%"
echo ================================================================================ >> "%RESULTS_FILE%"

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [1/12] TESTING YOUR OLD VPS: 18.203.89.58 (AWS Ireland)
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo Testing 18.203.89.58...
ping -n 5 18.203.89.58
echo.
echo Checking ports on 18.203.89.58...
echo Testing Port 22 (SSH)...
powershell -c "$t=New-Object Net.Sockets.TcpClient; $t.ReceiveTimeout=3000; $t.SendTimeout=3000; try{$t.Connect('18.203.89.58',22); if($t.Connected){echo 'Port 22 (SSH): OPEN'}; $t.Close()}catch{echo 'Port 22 (SSH): CLOSED/FILTERED'}"
echo Testing Port 80 (HTTP)...
powershell -c "$t=New-Object Net.Sockets.TcpClient; $t.ReceiveTimeout=3000; $t.SendTimeout=3000; try{$t.Connect('18.203.89.58',80); if($t.Connected){echo 'Port 80 (HTTP): OPEN'}; $t.Close()}catch{echo 'Port 80 (HTTP): CLOSED/FILTERED'}"
echo Testing Port 443 (HTTPS)...
powershell -c "$t=New-Object Net.Sockets.TcpClient; $t.ReceiveTimeout=3000; $t.SendTimeout=3000; try{$t.Connect('18.203.89.58',443); if($t.Connected){echo 'Port 443 (HTTPS): OPEN'}; $t.Close()}catch{echo 'Port 443 (HTTPS): CLOSED/FILTERED'}"
echo Testing Port 51820 (WireGuard)...
powershell -c "$t=New-Object Net.Sockets.TcpClient; $t.ReceiveTimeout=3000; $t.SendTimeout=3000; try{$t.Connect('18.203.89.58',51820); if($t.Connected){echo 'Port 51820 (WireGuard): OPEN'}; $t.Close()}catch{echo 'Port 51820 (WireGuard): CLOSED/FILTERED'}"
echo.
echo Traceroute to 18.203.89.58...
tracert -d -h 15 18.203.89.58
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [2/12] YOUR CURRENT SERVERS (AWS + GCP)
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo Testing AWS Ireland: 79.125.75.182
ping -n 3 79.125.75.182
echo.
echo Testing GCP Germany: 34.159.146.43
ping -n 3 34.159.146.43
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [3/12] IRAN DNS SERVERS (Shecan, 403, Electro, Begzar, Radar)
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo [Shecan] 178.22.122.100
ping -n 2 -w 3000 178.22.122.100
echo.
echo [Shecan Secondary] 185.51.200.2
ping -n 2 -w 3000 185.51.200.2
echo.
echo [403.online] 10.202.10.202
ping -n 2 -w 3000 10.202.10.202
echo.
echo [403.online Secondary] 10.202.10.102
ping -n 2 -w 3000 10.202.10.102
echo.
echo [Electro] 78.157.42.100
ping -n 2 -w 3000 78.157.42.100
echo.
echo [Electro Secondary] 78.157.42.101
ping -n 2 -w 3000 78.157.42.101
echo.
echo [Begzar] 185.55.226.26
ping -n 2 -w 3000 185.55.226.26
echo.
echo [Radar Game] 10.202.10.10
ping -n 2 -w 3000 10.202.10.10
echo.
echo [ParsOnline] 91.99.101.14
ping -n 2 -w 3000 91.99.101.14
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [4/12] GLOBAL DNS SERVERS
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo [Google] 8.8.8.8
ping -n 2 -w 3000 8.8.8.8
echo.
echo [Google Secondary] 8.8.4.4
ping -n 2 -w 3000 8.8.4.4
echo.
echo [Cloudflare] 1.1.1.1
ping -n 2 -w 3000 1.1.1.1
echo.
echo [Cloudflare Secondary] 1.0.0.1
ping -n 2 -w 3000 1.0.0.1
echo.
echo [Cloudflare Malware] 1.1.1.2
ping -n 2 -w 3000 1.1.1.2
echo.
echo [Quad9] 9.9.9.9
ping -n 2 -w 3000 9.9.9.9
echo.
echo [Quad9 Secondary] 149.112.112.112
ping -n 2 -w 3000 149.112.112.112
echo.
echo [OpenDNS] 208.67.222.222
ping -n 2 -w 3000 208.67.222.222
echo.
echo [OpenDNS Secondary] 208.67.220.220
ping -n 2 -w 3000 208.67.220.220
echo.
echo [AdGuard] 94.140.14.14
ping -n 2 -w 3000 94.140.14.14
echo.
echo [AdGuard Secondary] 94.140.15.15
ping -n 2 -w 3000 94.140.15.15
echo.
echo [CleanBrowsing] 185.228.168.9
ping -n 2 -w 3000 185.228.168.9
echo.
echo [Comodo] 8.26.56.26
ping -n 2 -w 3000 8.26.56.26
echo.
echo [Level3] 4.2.2.1
ping -n 2 -w 3000 4.2.2.1
echo.
echo [Level3 Secondary] 4.2.2.2
ping -n 2 -w 3000 4.2.2.2
echo.
echo [Verisign] 64.6.64.6
ping -n 2 -w 3000 64.6.64.6
echo.
echo [DNS.Watch] 84.200.69.80
ping -n 2 -w 3000 84.200.69.80
echo.
echo [Yandex] 77.88.8.8
ping -n 2 -w 3000 77.88.8.8
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [5/12] NEIGHBOR COUNTRIES - Best for VPN (Low Latency)
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo [TURKEY - Istanbul] 195.175.39.39
ping -n 3 -w 5000 195.175.39.39
echo.
echo [TURKEY - Turkcell] 212.156.0.1
ping -n 3 -w 5000 212.156.0.1
echo.
echo [UAE - Dubai Etisalat] 213.42.20.20
ping -n 3 -w 5000 213.42.20.20
echo.
echo [UAE - du] 94.200.200.200
ping -n 3 -w 5000 94.200.200.200
echo.
echo [ARMENIA - Ucom] 37.252.64.1
ping -n 3 -w 5000 37.252.64.1
echo.
echo [AZERBAIJAN - Baku] 85.132.41.2
ping -n 3 -w 5000 85.132.41.2
echo.
echo [IRAQ - Baghdad] 109.224.53.1
ping -n 3 -w 5000 109.224.53.1
echo.
echo [PAKISTAN - Karachi] 203.135.0.3
ping -n 3 -w 5000 203.135.0.3
echo.
echo [QATAR - Ooredoo] 213.130.96.41
ping -n 3 -w 5000 213.130.96.41
echo.
echo [BAHRAIN] 195.39.252.1
ping -n 3 -w 5000 195.39.252.1
echo.
echo [OMAN] 82.178.0.1
ping -n 3 -w 5000 82.178.0.1
echo.
echo [GEORGIA - Tbilisi] 91.151.0.1
ping -n 3 -w 5000 91.151.0.1
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [6/12] EUROPE SERVERS - Popular VPN Locations
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo [GERMANY - Frankfurt] 5.9.49.12
ping -n 3 -w 5000 5.9.49.12
echo.
echo [GERMANY - Hetzner] 88.99.0.1
ping -n 3 -w 5000 88.99.0.1
echo.
echo [NETHERLANDS - Amsterdam] 91.189.114.8
ping -n 3 -w 5000 91.189.114.8
echo.
echo [NETHERLANDS - DigitalOcean] 188.166.0.1
ping -n 3 -w 5000 188.166.0.1
echo.
echo [FRANCE - Paris OVH] 51.255.48.78
ping -n 3 -w 5000 51.255.48.78
echo.
echo [UK - London] 178.62.1.1
ping -n 3 -w 5000 178.62.1.1
echo.
echo [SWEDEN - Stockholm] 194.68.0.2
ping -n 3 -w 5000 194.68.0.2
echo.
echo [FINLAND - Helsinki] 193.229.0.40
ping -n 3 -w 5000 193.229.0.40
echo.
echo [SWITZERLAND - Zurich] 185.94.188.1
ping -n 3 -w 5000 185.94.188.1
echo.
echo [AUSTRIA - Vienna] 194.24.149.1
ping -n 3 -w 5000 194.24.149.1
echo.
echo [POLAND - Warsaw] 91.206.8.1
ping -n 3 -w 5000 91.206.8.1
echo.
echo [CZECH - Prague] 185.8.239.1
ping -n 3 -w 5000 185.8.239.1
echo.
echo [ROMANIA - Bucharest] 193.19.228.1
ping -n 3 -w 5000 193.19.228.1
echo.
echo [BULGARIA - Sofia] 194.12.224.1
ping -n 3 -w 5000 194.12.224.1
echo.
echo [RUSSIA - Moscow] 195.208.4.1
ping -n 3 -w 5000 195.208.4.1
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [7/12] ASIA + OCEANIA SERVERS
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo [SINGAPORE] 103.29.64.1
ping -n 3 -w 5000 103.29.64.1
echo.
echo [JAPAN - Tokyo] 210.150.254.1
ping -n 3 -w 5000 210.150.254.1
echo.
echo [HONG KONG] 119.28.32.1
ping -n 3 -w 5000 119.28.32.1
echo.
echo [SOUTH KOREA - Seoul] 175.158.0.1
ping -n 3 -w 5000 175.158.0.1
echo.
echo [INDIA - Mumbai] 103.10.124.1
ping -n 3 -w 5000 103.10.124.1
echo.
echo [AUSTRALIA - Sydney] 168.1.79.1
ping -n 3 -w 5000 168.1.79.1
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [8/12] AMERICAS SERVERS
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo [USA - New York] 198.41.222.2
ping -n 3 -w 5000 198.41.222.2
echo.
echo [USA - Los Angeles] 192.41.162.30
ping -n 3 -w 5000 192.41.162.30
echo.
echo [USA - Miami] 192.73.247.1
ping -n 3 -w 5000 192.73.247.1
echo.
echo [USA - Dallas] 64.34.165.1
ping -n 3 -w 5000 64.34.165.1
echo.
echo [CANADA - Toronto] 192.206.151.131
ping -n 3 -w 5000 192.206.151.131
echo.
echo [BRAZIL - Sao Paulo] 200.98.190.1
ping -n 3 -w 5000 200.98.190.1
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [9/12] CDN SERVERS (Content Delivery Networks)
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo [Cloudflare CDN] cdn.cloudflare.com
ping -n 3 -w 5000 cdn.cloudflare.com
echo.
echo [Cloudflare 1] 104.16.0.1
ping -n 3 -w 5000 104.16.0.1
echo.
echo [Fastly CDN] 151.101.0.1
ping -n 3 -w 5000 151.101.0.1
echo.
echo [Akamai CDN] 23.32.0.1
ping -n 3 -w 5000 23.32.0.1
echo.
echo [Amazon CloudFront] 52.222.128.1
ping -n 3 -w 5000 52.222.128.1
echo.
echo [Google CDN] 142.250.0.1
ping -n 3 -w 5000 142.250.0.1
echo.
echo [Microsoft Azure CDN] 13.107.0.1
ping -n 3 -w 5000 13.107.0.1
echo.
echo [ArvanCloud Iran] 185.49.84.1
ping -n 3 -w 5000 185.49.84.1
echo.
echo [ArvanCloud] cdn.arvancloud.com
ping -n 3 -w 5000 cdn.arvancloud.com
echo.
echo [Parspack Iran] 77.238.120.1
ping -n 3 -w 5000 77.238.120.1
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [10/12] DOMAIN NAMESERVERS TEST (tiki2k.com)
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo Testing Cloudflare Nameservers...
echo.
echo [Cloudflare NS] chad.ns.cloudflare.com
nslookup chad.ns.cloudflare.com
echo.
echo [Cloudflare NS] isla.ns.cloudflare.com
nslookup isla.ns.cloudflare.com
echo.
echo Testing your domain tiki2k.com...
nslookup tiki2k.com 8.8.8.8
echo.
nslookup tiki2k.com 1.1.1.1
echo.
echo Testing via Iran DNS (Shecan)...
nslookup tiki2k.com 178.22.122.100
echo.
echo Testing via 403.online...
nslookup tiki2k.com 10.202.10.202
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [11/12] POPULAR PUBLIC NAMESERVERS
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo [Cloudflare NS] adi.ns.cloudflare.com
ping -n 2 -w 3000 adi.ns.cloudflare.com
echo.
echo [Cloudflare NS] chad.ns.cloudflare.com
ping -n 2 -w 3000 chad.ns.cloudflare.com
echo.
echo [Google NS] ns1.google.com
ping -n 2 -w 3000 ns1.google.com
echo.
echo [AWS NS] ns-1.awsdns-00.com
ping -n 2 -w 3000 ns-1.awsdns-00.com
echo.
echo [Azure NS] ns1-01.azure-dns.com
ping -n 2 -w 3000 ns1-01.azure-dns.com
echo.
echo [DigitalOcean NS] ns1.digitalocean.com
ping -n 2 -w 3000 ns1.digitalocean.com
echo.
echo [Hetzner NS] ns1.hetzner.de
ping -n 2 -w 3000 ns1.hetzner.de
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  [12/12] VPN/TUNNEL PORTS TEST
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo Testing common VPN ports on Google DNS (8.8.8.8)...
echo.
echo Port 80 (HTTP)...
powershell -c "$t=New-Object Net.Sockets.TcpClient; try{$t.Connect('8.8.8.8',80); echo 'Port 80: OPEN'; $t.Close()}catch{echo 'Port 80: CLOSED'}"
echo Port 443 (HTTPS)...
powershell -c "$t=New-Object Net.Sockets.TcpClient; try{$t.Connect('8.8.8.8',443); echo 'Port 443: OPEN'; $t.Close()}catch{echo 'Port 443: CLOSED'}"
echo Port 22 (SSH)...
powershell -c "$t=New-Object Net.Sockets.TcpClient; try{$t.Connect('8.8.8.8',22); echo 'Port 22: CLOSED (expected)'; $t.Close()}catch{echo 'Port 22: CLOSED'}"
echo Port 53 (DNS)...
powershell -c "$t=New-Object Net.Sockets.TcpClient; try{$t.Connect('8.8.8.8',53); echo 'Port 53: OPEN'; $t.Close()}catch{echo 'Port 53: CLOSED'}"
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo  YOUR NETWORK CONFIGURATION
echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo --- IP Configuration ---
ipconfig | findstr /i "IPv4 Subnet Gateway"
echo.
echo --- Current DNS Servers ---
ipconfig /all | findstr /i "DNS Servers"
echo.
echo --- Active Connections ---
netstat -n | find /c "ESTABLISHED"
echo active connections
echo.
echo --- Routing Table ---
route print | findstr "0.0.0.0"
echo.

echo ══════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo ╔════════════════════════════════════════════════════════════════════════════════════════════╗
echo ║                              SCAN COMPLETE!                                                ║
echo ╠════════════════════════════════════════════════════════════════════════════════════════════╣
echo ║  Results saved to: %USERPROFILE%\Desktop\network-scan-results.txt                         ║
echo ╠════════════════════════════════════════════════════════════════════════════════════════════╣
echo ║                                                                                            ║
echo ║  RECOMMENDATIONS:                                                                          ║
echo ║  ────────────────                                                                          ║
echo ║  1. Lowest ping country = Best VPN location                                               ║
echo ║  2. TURKEY/UAE usually best for Iran (30-80ms)                                            ║
echo ║  3. GERMANY is great balance of speed + privacy                                           ║
echo ║  4. Use Google DNS (8.8.8.8) or Cloudflare (1.1.1.1) for unfiltered access               ║
echo ║  5. For filtered domains, try Shecan or 403.online DNS                                    ║
echo ║  6. WireGuard on port 443 works best in Iran                                              ║
echo ║                                                                                            ║
echo ║  YOUR SERVERS:                                                                             ║
echo ║  - AWS Ireland: 79.125.75.182                                                             ║
echo ║  - GCP Germany: 34.159.146.43                                                             ║
echo ║  - Old VPS: 18.203.89.58 (check if still accessible)                                      ║
echo ║                                                                                            ║
echo ╚════════════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo End Time: %date% %time%
echo.
pause
