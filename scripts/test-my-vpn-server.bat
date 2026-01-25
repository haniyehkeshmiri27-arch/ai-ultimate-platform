@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: ═══════════════════════════════════════════════════════════════════
:: تست کامل سرور VPN شما - تمام IP ها، پورت ها و پروتکل ها
:: نسخه 1.0 - طراحی شده برای ایران
:: ═══════════════════════════════════════════════════════════════════

title 🔥 تست سرور VPN شخصی - tiki2k

cls
echo.
echo  ╔════════════════════════════════════════════════════════════════════╗
echo  ║                   🔥 تست سرور VPN شخصی شما 🔥                      ║
echo  ║                     همه IP ها / پورت ها / پروتکل ها                ║
echo  ╠════════════════════════════════════════════════════════════════════╣
echo  ║  سرور: AWS Ireland ^(eu-west-1^)                                    ║
echo  ║  سیستم: Ubuntu 24.04 LTS                                           ║
echo  ║  منابع: 4 CPU / 16GB RAM / 100GB SSD                               ║
echo  ╚════════════════════════════════════════════════════════════════════╝
echo.

:: تعریف IP های سرور
set "IP1=108.128.15.3"
set "IP2=34.247.23.138"
set "IP3=63.32.250.131"

:: پورت های مهم
set "PORTS=22 80 443 51820 1194 8080 3128 8443 2222 9001"

:: فایل نتایج
set "RESULT_FILE=%USERPROFILE%\Desktop\VPN-Server-Test-Results.txt"

echo ═════════════════════════════════════════════════════════════════════
echo                        شروع تست در: %date% %time%
echo ═════════════════════════════════════════════════════════════════════

:: ذخیره در فایل
(
    echo ═══════════════════════════════════════════════════════════════════════════
    echo                        گزارش تست سرور VPN شخصی
    echo                        %date% %time%
    echo ═══════════════════════════════════════════════════════════════════════════
    echo.
) > "%RESULT_FILE%"

:: ════════════════════════════════════════════════════════════════════
:: بخش 1: تست پینگ IP ها
:: ════════════════════════════════════════════════════════════════════
echo.
echo ┌────────────────────────────────────────────────────────────────────┐
echo │                     📡 بخش 1: تست پینگ IP ها                       │
echo └────────────────────────────────────────────────────────────────────┘

echo.>> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo                    📡 بخش 1: تست پینگ IP ها                    >> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"

for %%I in (%IP1% %IP2% %IP3%) do (
    echo.
    echo   🎯 تست IP: %%I
    echo   ────────────────────────────────────────────
    
    set "PING_OK=0"
    for /f "tokens=*" %%A in ('ping -n 4 %%I 2^>nul ^| findstr /i "Average time Reply"') do (
        echo   %%A
        echo   %%A >> "%RESULT_FILE%"
        set "PING_OK=1"
    )
    
    if "!PING_OK!"=="0" (
        echo   ⚠️  پینگ بلاک شده یا بدون پاسخ
        echo   ⚠️  پینگ بلاک شده یا بدون پاسخ >> "%RESULT_FILE%"
    )
)

:: ════════════════════════════════════════════════════════════════════
:: بخش 2: تست TCP Ports با PowerShell
:: ════════════════════════════════════════════════════════════════════
echo.
echo.
echo ┌────────────────────────────────────────────────────────────────────┐
echo │                     🔌 بخش 2: تست پورت های TCP                     │
echo └────────────────────────────────────────────────────────────────────┘

echo.>> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo                    🔌 بخش 2: تست پورت های TCP                   >> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo.>> "%RESULT_FILE%"

echo.
echo   ┌─────────────────┬───────────────────────────────────────────────────┐
echo   │      پورت       │   %IP1%   │   %IP2%   │   %IP3%   │
echo   ├─────────────────┼───────────────────────────────────────────────────┤

echo   ┌─────────────────┬───────────────────────────────────────────────────┐>> "%RESULT_FILE%"
echo   │      پورت       │   IP1           │   IP2           │   IP3         │>> "%RESULT_FILE%"
echo   ├─────────────────┼───────────────────────────────────────────────────┤>> "%RESULT_FILE%"

for %%P in (%PORTS%) do (
    set "R1=-"
    set "R2=-"
    set "R3=-"
    
    :: تست IP1
    powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect('%IP1%',%%P);if($t.Connected){'✅'}else{'❌'}}catch{'❌'}finally{$t.Close()}" 2>nul > "%TEMP%\port_test.tmp"
    set /p R1=<"%TEMP%\port_test.tmp"
    
    :: تست IP2
    powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect('%IP2%',%%P);if($t.Connected){'✅'}else{'❌'}}catch{'❌'}finally{$t.Close()}" 2>nul > "%TEMP%\port_test.tmp"
    set /p R2=<"%TEMP%\port_test.tmp"
    
    :: تست IP3
    powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect('%IP3%',%%P);if($t.Connected){'✅'}else{'❌'}}catch{'❌'}finally{$t.Close()}" 2>nul > "%TEMP%\port_test.tmp"
    set /p R3=<"%TEMP%\port_test.tmp"
    
    echo   │ Port %%P		│       !R1!         │       !R2!         │       !R3!         │
    echo   │ Port %%P		│       !R1!         │       !R2!         │       !R3!         │>> "%RESULT_FILE%"
)
echo   └─────────────────┴───────────────────────────────────────────────────┘
echo   └─────────────────┴───────────────────────────────────────────────────┘>> "%RESULT_FILE%"

:: ════════════════════════════════════════════════════════════════════
:: بخش 3: تست پروتکل های VPN
:: ════════════════════════════════════════════════════════════════════
echo.
echo.
echo ┌────────────────────────────────────────────────────────────────────┐
echo │                     🔐 بخش 3: تست پروتکل های VPN                   │
echo └────────────────────────────────────────────────────────────────────┘

echo.>> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo                    🔐 بخش 3: تست پروتکل های VPN                  >> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo.>> "%RESULT_FILE%"

echo.
echo   ┌────────────────────────────────────────────────────────────────┐
echo   │ پروتکل           پورت         IP اول       IP دوم       IP سوم │
echo   ├────────────────────────────────────────────────────────────────┤

:: WireGuard UDP 51820
set "WG1=-" & set "WG2=-" & set "WG3=-"
for %%I in (1 2 3) do (
    if %%I==1 set "TESTIP=%IP1%"
    if %%I==2 set "TESTIP=%IP2%"
    if %%I==3 set "TESTIP=%IP3%"
    
    powershell -Command "$u=New-Object Net.Sockets.UdpClient;try{$u.Connect('!TESTIP!',51820);$u.Send([byte[]](1,0,0,0),4);'✅'}catch{'❌'}finally{$u.Close()}" 2>nul > "%TEMP%\udp_test.tmp"
    if %%I==1 set /p WG1=<"%TEMP%\udp_test.tmp"
    if %%I==2 set /p WG2=<"%TEMP%\udp_test.tmp"
    if %%I==3 set /p WG3=<"%TEMP%\udp_test.tmp"
)
echo   │ WireGuard         51820/UDP    %WG1%           %WG2%           %WG3%          │
echo   │ WireGuard         51820/UDP    %WG1%           %WG2%           %WG3%          │>> "%RESULT_FILE%"

:: OpenVPN UDP 1194
set "OV1=-" & set "OV2=-" & set "OV3=-"
for %%I in (1 2 3) do (
    if %%I==1 set "TESTIP=%IP1%"
    if %%I==2 set "TESTIP=%IP2%"
    if %%I==3 set "TESTIP=%IP3%"
    
    powershell -Command "$u=New-Object Net.Sockets.UdpClient;try{$u.Connect('!TESTIP!',1194);$u.Send([byte[]](56,1),2);'✅'}catch{'❌'}finally{$u.Close()}" 2>nul > "%TEMP%\udp_test.tmp"
    if %%I==1 set /p OV1=<"%TEMP%\udp_test.tmp"
    if %%I==2 set /p OV2=<"%TEMP%\udp_test.tmp"
    if %%I==3 set /p OV3=<"%TEMP%\udp_test.tmp"
)
echo   │ OpenVPN           1194/UDP     %OV1%           %OV2%           %OV3%          │
echo   │ OpenVPN           1194/UDP     %OV1%           %OV2%           %OV3%          │>> "%RESULT_FILE%"

:: SSH
set "S1=-" & set "S2=-" & set "S3=-"
for /f %%A in ('powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect(\"%IP1%\",22);if($t.Connected){\"✅\"}else{\"❌\"}}catch{\"❌\"}finally{$t.Close()}"') do set "S1=%%A"
for /f %%A in ('powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect(\"%IP2%\",22);if($t.Connected){\"✅\"}else{\"❌\"}}catch{\"❌\"}finally{$t.Close()}"') do set "S2=%%A"
for /f %%A in ('powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect(\"%IP3%\",22);if($t.Connected){\"✅\"}else{\"❌\"}}catch{\"❌\"}finally{$t.Close()}"') do set "S3=%%A"
echo   │ SSH               22/TCP       %S1%           %S2%           %S3%          │
echo   │ SSH               22/TCP       %S1%           %S2%           %S3%          │>> "%RESULT_FILE%"

:: HTTPS
set "H1=-" & set "H2=-" & set "H3=-"
for /f %%A in ('powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect(\"%IP1%\",443);if($t.Connected){\"✅\"}else{\"❌\"}}catch{\"❌\"}finally{$t.Close()}"') do set "H1=%%A"
for /f %%A in ('powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect(\"%IP2%\",443);if($t.Connected){\"✅\"}else{\"❌\"}}catch{\"❌\"}finally{$t.Close()}"') do set "H2=%%A"
for /f %%A in ('powershell -Command "$t=New-Object Net.Sockets.TcpClient;try{$t.Connect(\"%IP3%\",443);if($t.Connected){\"✅\"}else{\"❌\"}}catch{\"❌\"}finally{$t.Close()}"') do set "H3=%%A"
echo   │ HTTPS             443/TCP      %H1%           %H2%           %H3%          │
echo   │ HTTPS             443/TCP      %H1%           %H2%           %H3%          │>> "%RESULT_FILE%"

echo   └────────────────────────────────────────────────────────────────┘
echo   └────────────────────────────────────────────────────────────────┘>> "%RESULT_FILE%"

:: ════════════════════════════════════════════════════════════════════
:: بخش 4: تست سرعت دانلود
:: ════════════════════════════════════════════════════════════════════
echo.
echo.
echo ┌────────────────────────────────────────────────────────────────────┐
echo │                     📥 بخش 4: تست سرعت دانلود                      │
echo └────────────────────────────────────────────────────────────────────┘

echo.>> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo                    📥 بخش 4: تست سرعت دانلود                     >> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo.>> "%RESULT_FILE%"

for %%I in (%IP1% %IP2% %IP3%) do (
    echo.
    echo   🌐 تست دانلود از %%I:80 ...
    powershell -Command "$sw=[Diagnostics.Stopwatch]::StartNew();try{$wc=New-Object Net.WebClient;$null=$wc.DownloadString('http://%%I/');$sw.Stop();Write-Host ('      ✅ پاسخ HTTP در ' + $sw.ElapsedMilliseconds + ' ms')}catch{Write-Host '      ⚠️ HTTP پاسخ نداد (سرویس نصب نشده)'}" 2>nul
)

:: ════════════════════════════════════════════════════════════════════
:: بخش 5: تست Traceroute
:: ════════════════════════════════════════════════════════════════════
echo.
echo.
echo ┌────────────────────────────────────────────────────────────────────┐
echo │                     🛤️ بخش 5: مسیریابی (Traceroute)                 │
echo └────────────────────────────────────────────────────────────────────┘

echo.>> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo                    🛤️ بخش 5: مسیریابی (Traceroute)               >> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo.>> "%RESULT_FILE%"

echo.
echo   مسیر تا IP اول (%IP1%):
echo   ─────────────────────────────────────────────
echo   مسیر تا IP اول (%IP1%):>> "%RESULT_FILE%"
tracert -d -h 15 %IP1% 2>nul | findstr /r "^  *[0-9]" | head -10
tracert -d -h 15 %IP1% 2>nul | findstr /r "^  *[0-9]" >> "%RESULT_FILE%"

:: ════════════════════════════════════════════════════════════════════
:: بخش 6: تست DNS و Resolve
:: ════════════════════════════════════════════════════════════════════
echo.
echo.
echo ┌────────────────────────────────────────────────────────────────────┐
echo │                     🔍 بخش 6: تست DNS (اختیاری)                    │
echo └────────────────────────────────────────────────────────────────────┘

echo.
echo   اگر دامنه به سرور متصل شده:
echo   nslookup vpn.tiki2k.com
echo.

:: ════════════════════════════════════════════════════════════════════
:: خلاصه نتایج
:: ════════════════════════════════════════════════════════════════════
echo.
echo ╔════════════════════════════════════════════════════════════════════╗
echo ║                         📊 خلاصه نتایج                             ║
echo ╠════════════════════════════════════════════════════════════════════╣
echo ║  IP های سرور شما:                                                  ║
echo ║    🟢 Primary:   %IP1%                                        ║
echo ║    🟢 Secondary: %IP2%                                       ║
echo ║    🟢 Tertiary:  %IP3%                                       ║
echo ╠════════════════════════════════════════════════════════════════════╣
echo ║  اگر پینگ بلاک است اما پورت ها باز: سرور سالم است!               ║
echo ║  ایران معمولا ICMP (پینگ) را فیلتر می کند                          ║
echo ╠════════════════════════════════════════════════════════════════════╣
echo ║  پورت های مهم:                                                     ║
echo ║    22   - SSH                                                      ║
echo ║    443  - HTTPS / OpenVPN-TCP                                      ║
echo ║    51820- WireGuard                                                ║
echo ║    1194 - OpenVPN-UDP                                              ║
echo ╚════════════════════════════════════════════════════════════════════╝
echo.

echo.>> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo                         📊 خلاصه                                >> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"
echo   IP های سرور: %IP1%, %IP2%, %IP3%>> "%RESULT_FILE%"
echo   تست انجام شد در: %date% %time%>> "%RESULT_FILE%"
echo ══════════════════════════════════════════════════════════════>> "%RESULT_FILE%"

echo.
echo 📄 نتایج ذخیره شد در: %RESULT_FILE%
echo.
echo ─────────────────────────────────────────────────────────────────────
echo   تست کامل شد! حالا می تونید ببینید کدوم IP ها از ایران در دسترسه
echo ─────────────────────────────────────────────────────────────────────
echo.

pause
