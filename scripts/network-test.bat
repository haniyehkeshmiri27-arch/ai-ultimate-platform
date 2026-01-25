@echo off
chcp 65001 >nul 2>&1
title Network Test Tool - Iran
color 0A

echo ================================================================
echo            NETWORK TEST TOOL - FULL SCAN
echo            Testing from Iran
echo ================================================================
echo.

echo [%date% %time%] Starting Network Test...
echo.

:: Create output file
set OUTPUT=%USERPROFILE%\Desktop\network-test-result.txt
echo ================================================================ > "%OUTPUT%"
echo NETWORK TEST RESULTS >> "%OUTPUT%"
echo Date: %date% %time% >> "%OUTPUT%"
echo ================================================================ >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ============================================
:: 1. IP ADDRESS
:: ============================================
echo [1/8] Testing IP Address...
echo === IP ADDRESS === >> "%OUTPUT%"
curl -s --connect-timeout 10 ifconfig.me >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"
curl -s --connect-timeout 10 ipinfo.io >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ============================================
:: 2. DNS CONFIGURATION
:: ============================================
echo [2/8] Checking DNS Configuration...
echo === DNS CONFIGURATION === >> "%OUTPUT%"
ipconfig /all | findstr /i "DNS" >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: 3. PING TESTS
:: ============================================
echo [3/8] Testing Ping...
echo === PING TESTS === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo Testing 8.8.8.8 (Google DNS)... >> "%OUTPUT%"
ping -n 2 -w 3000 8.8.8.8 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

echo Testing 1.1.1.1 (Cloudflare)... >> "%OUTPUT%"
ping -n 2 -w 3000 1.1.1.1 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

echo Testing 4.2.2.4 (Level3)... >> "%OUTPUT%"
ping -n 2 -w 3000 4.2.2.4 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: 4. DNS RESOLUTION TESTS
:: ============================================
echo [4/8] Testing DNS Resolution...
echo === DNS RESOLUTION TESTS === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo Testing Google DNS (8.8.8.8)... >> "%OUTPUT%"
nslookup google.com 8.8.8.8 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

echo Testing Cloudflare DNS (1.1.1.1)... >> "%OUTPUT%"
nslookup google.com 1.1.1.1 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

echo Testing Quad9 DNS (9.9.9.9)... >> "%OUTPUT%"
nslookup google.com 9.9.9.9 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

echo Testing Shecan DNS (178.22.122.100)... >> "%OUTPUT%"
nslookup google.com 178.22.122.100 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

echo Testing 403 DNS (10.202.10.202)... >> "%OUTPUT%"
nslookup google.com 10.202.10.202 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: 5. WEBSITE ACCESSIBILITY TESTS
:: ============================================
echo [5/8] Testing Website Access...
echo === WEBSITE ACCESSIBILITY TESTS === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo Testing google.com... >> "%OUTPUT%"
curl -s -o nul -w "google.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://google.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo google.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing youtube.com... >> "%OUTPUT%"
curl -s -o nul -w "youtube.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://youtube.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo youtube.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing twitter.com... >> "%OUTPUT%"
curl -s -o nul -w "twitter.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://twitter.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo twitter.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing telegram.org... >> "%OUTPUT%"
curl -s -o nul -w "telegram.org: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://telegram.org >> "%OUTPUT%" 2>&1
if errorlevel 1 echo telegram.org: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing instagram.com... >> "%OUTPUT%"
curl -s -o nul -w "instagram.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://instagram.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo instagram.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing facebook.com... >> "%OUTPUT%"
curl -s -o nul -w "facebook.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://facebook.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo facebook.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing whatsapp.com... >> "%OUTPUT%"
curl -s -o nul -w "whatsapp.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://whatsapp.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo whatsapp.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing github.com... >> "%OUTPUT%"
curl -s -o nul -w "github.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://github.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo github.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing raw.githubusercontent.com... >> "%OUTPUT%"
curl -s -o nul -w "raw.githubusercontent.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://raw.githubusercontent.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo raw.githubusercontent.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing stackoverflow.com... >> "%OUTPUT%"
curl -s -o nul -w "stackoverflow.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://stackoverflow.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo stackoverflow.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing discord.com... >> "%OUTPUT%"
curl -s -o nul -w "discord.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://discord.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo discord.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing openai.com... >> "%OUTPUT%"
curl -s -o nul -w "openai.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://openai.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo openai.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo Testing cloudflare.com... >> "%OUTPUT%"
curl -s -o nul -w "cloudflare.com: HTTP %%{http_code} - Time: %%{time_total}s\n" --connect-timeout 10 https://cloudflare.com >> "%OUTPUT%" 2>&1
if errorlevel 1 echo cloudflare.com: BLOCKED/TIMEOUT >> "%OUTPUT%"

echo. >> "%OUTPUT%"

:: ============================================
:: 6. PORT TESTS
:: ============================================
echo [6/8] Testing Ports...
echo === PORT TESTS (to 8.8.8.8) === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo Testing Port 80 (HTTP)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 80); Write-Host 'Port 80 (HTTP): OPEN' } catch { Write-Host 'Port 80 (HTTP): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo Testing Port 443 (HTTPS)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 443); Write-Host 'Port 443 (HTTPS): OPEN' } catch { Write-Host 'Port 443 (HTTPS): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo Testing Port 22 (SSH)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 22); Write-Host 'Port 22 (SSH): OPEN' } catch { Write-Host 'Port 22 (SSH): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo Testing Port 53 (DNS)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 53); Write-Host 'Port 53 (DNS): OPEN' } catch { Write-Host 'Port 53 (DNS): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo Testing Port 1080 (SOCKS)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 1080); Write-Host 'Port 1080 (SOCKS): OPEN' } catch { Write-Host 'Port 1080 (SOCKS): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo Testing Port 1194 (OpenVPN)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 1194); Write-Host 'Port 1194 (OpenVPN): OPEN' } catch { Write-Host 'Port 1194 (OpenVPN): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo Testing Port 8080 (HTTP-Alt)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 8080); Write-Host 'Port 8080 (HTTP-Alt): OPEN' } catch { Write-Host 'Port 8080 (HTTP-Alt): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo Testing Port 8443 (HTTPS-Alt)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 8443); Write-Host 'Port 8443 (HTTPS-Alt): OPEN' } catch { Write-Host 'Port 8443 (HTTPS-Alt): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo Testing Port 51820 (WireGuard)...
powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('8.8.8.8', 51820); Write-Host 'Port 51820 (WireGuard): OPEN' } catch { Write-Host 'Port 51820 (WireGuard): BLOCKED' } finally { $tcp.Close() }" >> "%OUTPUT%" 2>&1

echo. >> "%OUTPUT%"

:: ============================================
:: 7. TRACEROUTE
:: ============================================
echo [7/8] Running Traceroute...
echo === TRACEROUTE TO 8.8.8.8 === >> "%OUTPUT%"
tracert -h 15 -w 2000 8.8.8.8 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: 8. SPEED TEST
:: ============================================
echo [8/8] Testing Download Speed...
echo === SPEED TEST === >> "%OUTPUT%"
echo Testing download speed from Cloudflare... >> "%OUTPUT%"
curl -s -o nul -w "Download Speed: %%{speed_download} bytes/sec\nTotal Time: %%{time_total}s\n" --connect-timeout 30 https://speed.cloudflare.com/__down?bytes=5000000 >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: NETWORK INTERFACES
:: ============================================
echo === NETWORK INTERFACES === >> "%OUTPUT%"
ipconfig /all >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: ROUTING TABLE
:: ============================================
echo === ROUTING TABLE === >> "%OUTPUT%"
route print >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

:: ============================================
:: ACTIVE CONNECTIONS
:: ============================================
echo === ACTIVE CONNECTIONS === >> "%OUTPUT%"
netstat -an | findstr "ESTABLISHED LISTENING" >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

echo ================================================================ >> "%OUTPUT%"
echo TEST COMPLETED >> "%OUTPUT%"
echo ================================================================ >> "%OUTPUT%"

echo.
echo ================================================================
echo                    TEST COMPLETED!
echo ================================================================
echo.
echo Results saved to: %OUTPUT%
echo.
echo Opening results file...
notepad "%OUTPUT%"

echo.
echo Please copy the content of the file and send it to me!
echo.
pause
