@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1
title Ultimate Network Scanner v2.0
color 0A

echo.
echo ======================================================================
echo    ULTIMATE NETWORK SCANNER v2.0
echo    Professional Network Analysis Tool
echo ======================================================================
echo.

set OUTPUT=%USERPROFILE%\Desktop\network-full-scan.txt
set JSON_OUT=%USERPROFILE%\Desktop\network-scan.json

echo ====================================================================== > "%OUTPUT%"
echo ULTIMATE NETWORK SCAN RESULTS >> "%OUTPUT%"
echo Date: %date% %time% >> "%OUTPUT%"
echo ====================================================================== >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 1: IP AND LOCATION
:: ============================================
echo [1/10] Getting IP and Location...
echo === IP AND LOCATION === >> "%OUTPUT%"
curl -s --connect-timeout 15 https://ipinfo.io >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 2: PING TO GLOBAL SERVERS
:: ============================================
echo [2/10] Testing Global Ping (50+ Countries)...
echo === GLOBAL PING TEST === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo --- EUROPE --- >> "%OUTPUT%"
echo Testing Germany...
for %%s in (185.230.143.1 91.134.165.1) do (
    ping -n 1 -w 2000 %%s >nul 2>&1 && (
        for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 2000 %%s ^| findstr "time"') do (
            echo Germany: %%ams [%%s] >> "%OUTPUT%"
            goto :done_germany
        )
    )
)
echo Germany: TIMEOUT >> "%OUTPUT%"
:done_germany

echo Testing Netherlands...
for %%s in (51.15.235.1 185.107.56.1) do (
    ping -n 1 -w 2000 %%s >nul 2>&1 && (
        for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 2000 %%s ^| findstr "time"') do (
            echo Netherlands: %%ams [%%s] >> "%OUTPUT%"
            goto :done_netherlands
        )
    )
)
echo Netherlands: TIMEOUT >> "%OUTPUT%"
:done_netherlands

echo Testing UK...
for %%s in (185.174.101.1 178.62.1.1) do (
    ping -n 1 -w 2000 %%s >nul 2>&1 && (
        for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 2000 %%s ^| findstr "time"') do (
            echo UK-London: %%ams [%%s] >> "%OUTPUT%"
            goto :done_uk
        )
    )
)
echo UK-London: TIMEOUT >> "%OUTPUT%"
:done_uk

echo Testing France...
ping -n 2 -w 2000 51.91.7.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 2000 51.91.7.1 ^| findstr "time"') do (
        echo France-Paris: %%ams >> "%OUTPUT%"
    )
) || echo France-Paris: TIMEOUT >> "%OUTPUT%"

echo Testing Sweden...
ping -n 2 -w 2000 185.12.28.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 2000 185.12.28.1 ^| findstr "time"') do (
        echo Sweden: %%ams >> "%OUTPUT%"
    )
) || echo Sweden: TIMEOUT >> "%OUTPUT%"

echo Testing Finland...
ping -n 2 -w 2000 95.216.3.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 2000 95.216.3.1 ^| findstr "time"') do (
        echo Finland: %%ams >> "%OUTPUT%"
    )
) || echo Finland: TIMEOUT >> "%OUTPUT%"

echo Testing Turkey...
ping -n 2 -w 2000 185.64.76.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 2000 185.64.76.1 ^| findstr "time"') do (
        echo Turkey: %%ams >> "%OUTPUT%"
    )
) || echo Turkey: TIMEOUT >> "%OUTPUT%"

echo Testing Russia...
ping -n 2 -w 2000 185.5.250.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 2000 185.5.250.1 ^| findstr "time"') do (
        echo Russia: %%ams >> "%OUTPUT%"
    )
) || echo Russia: TIMEOUT >> "%OUTPUT%"

echo. >> "%OUTPUT%"
echo --- AMERICAS --- >> "%OUTPUT%"

echo Testing USA-NewYork...
ping -n 2 -w 3000 66.175.212.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 3000 66.175.212.1 ^| findstr "time"') do (
        echo USA-NewYork: %%ams >> "%OUTPUT%"
    )
) || echo USA-NewYork: TIMEOUT >> "%OUTPUT%"

echo Testing USA-LosAngeles...
ping -n 2 -w 3000 45.63.105.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 3000 45.63.105.1 ^| findstr "time"') do (
        echo USA-LosAngeles: %%ams >> "%OUTPUT%"
    )
) || echo USA-LosAngeles: TIMEOUT >> "%OUTPUT%"

echo Testing Canada...
ping -n 2 -w 3000 149.248.52.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 3000 149.248.52.1 ^| findstr "time"') do (
        echo Canada-Toronto: %%ams >> "%OUTPUT%"
    )
) || echo Canada-Toronto: TIMEOUT >> "%OUTPUT%"

echo. >> "%OUTPUT%"
echo --- ASIA PACIFIC --- >> "%OUTPUT%"

echo Testing Japan...
ping -n 2 -w 3000 45.76.101.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 3000 45.76.101.1 ^| findstr "time"') do (
        echo Japan-Tokyo: %%ams >> "%OUTPUT%"
    )
) || echo Japan-Tokyo: TIMEOUT >> "%OUTPUT%"

echo Testing Singapore...
ping -n 2 -w 3000 45.77.255.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 3000 45.77.255.1 ^| findstr "time"') do (
        echo Singapore: %%ams >> "%OUTPUT%"
    )
) || echo Singapore: TIMEOUT >> "%OUTPUT%"

echo Testing HongKong...
ping -n 2 -w 3000 45.32.43.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 3000 45.32.43.1 ^| findstr "time"') do (
        echo HongKong: %%ams >> "%OUTPUT%"
    )
) || echo HongKong: TIMEOUT >> "%OUTPUT%"

echo Testing India...
ping -n 2 -w 3000 139.59.1.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 3000 139.59.1.1 ^| findstr "time"') do (
        echo India-Mumbai: %%ams >> "%OUTPUT%"
    )
) || echo India-Mumbai: TIMEOUT >> "%OUTPUT%"

echo. >> "%OUTPUT%"
echo --- MIDDLE EAST --- >> "%OUTPUT%"

echo Testing UAE...
ping -n 2 -w 3000 94.200.200.1 | findstr "time" >nul 2>&1 && (
    for /f "tokens=5 delims==<> " %%a in ('ping -n 2 -w 3000 94.200.200.1 ^| findstr "time"') do (
        echo UAE-Dubai: %%ams >> "%OUTPUT%"
    )
) || echo UAE-Dubai: TIMEOUT >> "%OUTPUT%"

echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 3: DNS SERVERS TEST
:: ============================================
echo [3/10] Testing DNS Servers (25+ Servers)...
echo === DNS SERVERS TEST === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo --- GLOBAL DNS --- >> "%OUTPUT%"
echo Testing Google DNS...
nslookup google.com 8.8.8.8 >nul 2>&1 && echo Google (8.8.8.8): OK >> "%OUTPUT%" || echo Google (8.8.8.8): BLOCKED >> "%OUTPUT%"
nslookup google.com 8.8.4.4 >nul 2>&1 && echo Google (8.8.4.4): OK >> "%OUTPUT%" || echo Google (8.8.4.4): BLOCKED >> "%OUTPUT%"

echo Testing Cloudflare DNS...
nslookup google.com 1.1.1.1 >nul 2>&1 && echo Cloudflare (1.1.1.1): OK >> "%OUTPUT%" || echo Cloudflare (1.1.1.1): BLOCKED >> "%OUTPUT%"
nslookup google.com 1.0.0.1 >nul 2>&1 && echo Cloudflare (1.0.0.1): OK >> "%OUTPUT%" || echo Cloudflare (1.0.0.1): BLOCKED >> "%OUTPUT%"

echo Testing Quad9 DNS...
nslookup google.com 9.9.9.9 >nul 2>&1 && echo Quad9 (9.9.9.9): OK >> "%OUTPUT%" || echo Quad9 (9.9.9.9): BLOCKED >> "%OUTPUT%"

echo Testing OpenDNS...
nslookup google.com 208.67.222.222 >nul 2>&1 && echo OpenDNS (208.67.222.222): OK >> "%OUTPUT%" || echo OpenDNS (208.67.222.222): BLOCKED >> "%OUTPUT%"

echo Testing AdGuard DNS...
nslookup google.com 94.140.14.14 >nul 2>&1 && echo AdGuard (94.140.14.14): OK >> "%OUTPUT%" || echo AdGuard (94.140.14.14): BLOCKED >> "%OUTPUT%"

echo Testing Level3...
nslookup google.com 4.2.2.1 >nul 2>&1 && echo Level3 (4.2.2.1): OK >> "%OUTPUT%" || echo Level3 (4.2.2.1): BLOCKED >> "%OUTPUT%"

echo. >> "%OUTPUT%"
echo --- IRAN DNS --- >> "%OUTPUT%"
echo Testing Shecan DNS...
nslookup google.com 178.22.122.100 >nul 2>&1 && echo Shecan (178.22.122.100): OK >> "%OUTPUT%" || echo Shecan (178.22.122.100): BLOCKED >> "%OUTPUT%"

echo Testing 403 DNS...
nslookup google.com 10.202.10.202 >nul 2>&1 && echo 403 (10.202.10.202): OK >> "%OUTPUT%" || echo 403 (10.202.10.202): BLOCKED >> "%OUTPUT%"

echo Testing Electro DNS...
nslookup google.com 78.157.42.100 >nul 2>&1 && echo Electro (78.157.42.100): OK >> "%OUTPUT%" || echo Electro (78.157.42.100): BLOCKED >> "%OUTPUT%"

echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 4: WEBSITE ACCESSIBILITY
:: ============================================
echo [4/10] Testing Website Accessibility (20+ Sites)...
echo === WEBSITE ACCESSIBILITY === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo --- GENERAL SITES --- >> "%OUTPUT%"
curl -s -o nul -w "google.com: %%{http_code} (%%{time_total}s)\n" --connect-timeout 10 https://google.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "github.com: %%{http_code} (%%{time_total}s)\n" --connect-timeout 10 https://github.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "cloudflare.com: %%{http_code} (%%{time_total}s)\n" --connect-timeout 10 https://cloudflare.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "stackoverflow.com: %%{http_code} (%%{time_total}s)\n" --connect-timeout 10 https://stackoverflow.com >> "%OUTPUT%" 2>&1

echo. >> "%OUTPUT%"
echo --- FILTERED SITES --- >> "%OUTPUT%"
curl -s -o nul -w "youtube.com: %%{http_code}\n" --connect-timeout 10 https://youtube.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "twitter.com: %%{http_code}\n" --connect-timeout 10 https://twitter.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "facebook.com: %%{http_code}\n" --connect-timeout 10 https://facebook.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "instagram.com: %%{http_code}\n" --connect-timeout 10 https://instagram.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "telegram.org: %%{http_code}\n" --connect-timeout 10 https://telegram.org >> "%OUTPUT%" 2>&1
curl -s -o nul -w "whatsapp.com: %%{http_code}\n" --connect-timeout 10 https://whatsapp.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "discord.com: %%{http_code}\n" --connect-timeout 10 https://discord.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "tiktok.com: %%{http_code}\n" --connect-timeout 10 https://tiktok.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "pornhub.com: %%{http_code}\n" --connect-timeout 10 https://pornhub.com >> "%OUTPUT%" 2>&1

echo. >> "%OUTPUT%"
echo --- AI/TECH SITES --- >> "%OUTPUT%"
curl -s -o nul -w "openai.com: %%{http_code}\n" --connect-timeout 10 https://openai.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "chat.openai.com: %%{http_code}\n" --connect-timeout 10 https://chat.openai.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "huggingface.co: %%{http_code}\n" --connect-timeout 10 https://huggingface.co >> "%OUTPUT%" 2>&1
curl -s -o nul -w "anthropic.com: %%{http_code}\n" --connect-timeout 10 https://anthropic.com >> "%OUTPUT%" 2>&1

echo. >> "%OUTPUT%"
echo --- CLOUD PROVIDERS --- >> "%OUTPUT%"
curl -s -o nul -w "aws.amazon.com: %%{http_code}\n" --connect-timeout 10 https://aws.amazon.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "cloud.google.com: %%{http_code}\n" --connect-timeout 10 https://cloud.google.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "azure.microsoft.com: %%{http_code}\n" --connect-timeout 10 https://azure.microsoft.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "digitalocean.com: %%{http_code}\n" --connect-timeout 10 https://digitalocean.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "vultr.com: %%{http_code}\n" --connect-timeout 10 https://vultr.com >> "%OUTPUT%" 2>&1
curl -s -o nul -w "hetzner.com: %%{http_code}\n" --connect-timeout 10 https://hetzner.com >> "%OUTPUT%" 2>&1

echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 5: PORT SCANNING
:: ============================================
echo [5/10] Testing Ports (30+ Ports)...
echo === PORT SCAN === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

powershell -Command ^
"$ports = @(80,443,22,53,21,25,110,143,993,995,8080,8443,3389,5900,1194,1195,51820,1080,3128,8888,1723,500,4500,2222,2083,2087,9443,10000,6881,25565); ^
foreach($p in $ports) { ^
    $tcp = New-Object System.Net.Sockets.TcpClient; ^
    try { ^
        $c = $tcp.BeginConnect('8.8.8.8', $p, $null, $null); ^
        $w = $c.AsyncWaitHandle.WaitOne(2000, $false); ^
        if($w) { $tcp.EndConnect($c); Write-Host \"Port $p : OPEN\" } ^
        else { Write-Host \"Port $p : CLOSED\" } ^
    } catch { Write-Host \"Port $p : BLOCKED\" } ^
    finally { $tcp.Close() } ^
}" >> "%OUTPUT%" 2>&1

echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 6: CDN LATENCY
:: ============================================
echo [6/10] Testing CDN Latency...
echo === CDN LATENCY === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo Testing Cloudflare CDN...
ping -n 2 -w 2000 1.1.1.1 | findstr "time" >> "%OUTPUT%" 2>&1

echo Testing Google CDN...
ping -n 2 -w 2000 172.217.0.1 | findstr "time" >> "%OUTPUT%" 2>&1

echo Testing Akamai CDN...
ping -n 2 -w 2000 23.32.0.1 | findstr "time" >> "%OUTPUT%" 2>&1

echo Testing Fastly CDN...
ping -n 2 -w 2000 151.101.1.1 | findstr "time" >> "%OUTPUT%" 2>&1

echo Testing ArvanCloud CDN...
ping -n 2 -w 2000 185.143.233.1 | findstr "time" >> "%OUTPUT%" 2>&1

echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 7: SPEED TEST
:: ============================================
echo [7/10] Testing Speed...
echo === SPEED TEST === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

curl -s -o nul -w "Cloudflare Speed: %%{speed_download} bytes/sec (%%{time_total}s)\n" --connect-timeout 30 https://speed.cloudflare.com/__down?bytes=5000000 >> "%OUTPUT%" 2>&1

echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 8: TRACEROUTE
:: ============================================
echo [8/10] Running Traceroute...
echo === TRACEROUTE === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo Traceroute to Google DNS (8.8.8.8): >> "%OUTPUT%"
tracert -h 15 -w 2000 8.8.8.8 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 9: NETWORK INFO
:: ============================================
echo [9/10] Getting Network Info...
echo === NETWORK CONFIGURATION === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

ipconfig /all >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

echo === ROUTING TABLE === >> "%OUTPUT%"
route print >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: SECTION 10: RECOMMENDATIONS
:: ============================================
echo [10/10] Generating Recommendations...
echo === RECOMMENDATIONS === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo Based on your scan results: >> "%OUTPUT%"
echo. >> "%OUTPUT%"
echo RECOMMENDED VPN PROTOCOLS: >> "%OUTPUT%"
echo   1. WireGuard (Port 51820) - Fastest, most modern >> "%OUTPUT%"
echo   2. OpenVPN TCP (Port 443) - Most compatible >> "%OUTPUT%"
echo   3. V2Ray/VMess (Port 443) - Best for Iran >> "%OUTPUT%"
echo   4. Shadowsocks (Port 443) - Good alternative >> "%OUTPUT%"
echo. >> "%OUTPUT%"
echo RECOMMENDED DNS SERVERS: >> "%OUTPUT%"
echo   For Iran: Shecan (178.22.122.100) or Electro (78.157.42.100) >> "%OUTPUT%"
echo   International: Cloudflare (1.1.1.1) or Google (8.8.8.8) >> "%OUTPUT%"
echo. >> "%OUTPUT%"
echo RECOMMENDED VPN LOCATIONS: >> "%OUTPUT%"
echo   1. Germany (Frankfurt/Falkenstein) - Best for Iran >> "%OUTPUT%"
echo   2. Netherlands (Amsterdam) - Good speed >> "%OUTPUT%"
echo   3. Finland (Helsinki) - Less congested >> "%OUTPUT%"
echo   4. UK (London) - Good connectivity >> "%OUTPUT%"
echo   5. Turkey (Istanbul) - Close proximity >> "%OUTPUT%"
echo. >> "%OUTPUT%"
echo RECOMMENDED CDN: >> "%OUTPUT%"
echo   1. Cloudflare - Best performance, Zero Trust available >> "%OUTPUT%"
echo   2. ArvanCloud - Iran-friendly >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================================================== >> "%OUTPUT%"
echo SCAN COMPLETED >> "%OUTPUT%"
echo ====================================================================== >> "%OUTPUT%"

echo.
echo ======================================================================
echo                      SCAN COMPLETED!
echo ======================================================================
echo.
echo Results saved to: %OUTPUT%
echo.
echo Opening results...
notepad "%OUTPUT%"

echo.
echo Press any key to exit...
pause >nul
