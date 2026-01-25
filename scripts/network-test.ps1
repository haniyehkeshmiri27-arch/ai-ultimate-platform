# 🔍 اسکریپت تست شبکه برای ایران - ویندوز
# این فایل را با PowerShell اجرا کنید

Write-Host "========================================"
Write-Host "🔍 تست کامل شبکه و اینترنت" -ForegroundColor Cyan
Write-Host "========================================"
Write-Host ""

# IP و کشور
Write-Host "📍 === اطلاعات IP ===" -ForegroundColor Yellow
try {
    $ip = (Invoke-WebRequest -Uri "https://ifconfig.me" -UseBasicParsing -TimeoutSec 10).Content
    Write-Host "IP: $ip"
    $ipinfo = (Invoke-WebRequest -Uri "https://ipinfo.io" -UseBasicParsing -TimeoutSec 10).Content | ConvertFrom-Json
    Write-Host "شهر: $($ipinfo.city)"
    Write-Host "کشور: $($ipinfo.country)"
    Write-Host "ISP: $($ipinfo.org)"
} catch {
    Write-Host "❌ خطا در دریافت IP" -ForegroundColor Red
}
Write-Host ""

# DNS
Write-Host "🌐 === تنظیمات DNS ===" -ForegroundColor Yellow
Get-DnsClientServerAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, ServerAddresses | Format-Table
Write-Host ""

# تست سایت‌ها
Write-Host "🚫 === تست سایت‌های معمولاً فیلتر شده ===" -ForegroundColor Yellow
$sites = @("google.com", "youtube.com", "twitter.com", "telegram.org", "facebook.com", "instagram.com", "whatsapp.com", "github.com")

foreach ($site in $sites) {
    try {
        $response = Invoke-WebRequest -Uri "https://$site" -UseBasicParsing -TimeoutSec 5 -MaximumRedirection 0 -ErrorAction SilentlyContinue
        Write-Host "✅ ${site}: OPEN" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -ge 300 -and $_.Exception.Response.StatusCode.value__ -lt 400) {
            Write-Host "✅ ${site}: OPEN (Redirect)" -ForegroundColor Green
        } else {
            Write-Host "❌ ${site}: BLOCKED/ERROR" -ForegroundColor Red
        }
    }
}
Write-Host ""

# تست پورت‌ها
Write-Host "🔌 === تست پورت‌های خروجی ===" -ForegroundColor Yellow
$ports = @(
    @{Port=22; Name="SSH"},
    @{Port=80; Name="HTTP"},
    @{Port=443; Name="HTTPS"},
    @{Port=8080; Name="Alt-HTTP"},
    @{Port=1080; Name="SOCKS"},
    @{Port=1194; Name="OpenVPN"},
    @{Port=51820; Name="WireGuard"},
    @{Port=4500; Name="IPSec-NAT"}
)

foreach ($p in $ports) {
    $tcp = New-Object System.Net.Sockets.TcpClient
    try {
        $connect = $tcp.BeginConnect("8.8.8.8", $p.Port, $null, $null)
        $wait = $connect.AsyncWaitHandle.WaitOne(3000, $false)
        if ($wait) {
            $tcp.EndConnect($connect)
            Write-Host "✅ Port $($p.Port) ($($p.Name)): OPEN" -ForegroundColor Green
        } else {
            Write-Host "❌ Port $($p.Port) ($($p.Name)): BLOCKED" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Port $($p.Port) ($($p.Name)): BLOCKED" -ForegroundColor Red
    } finally {
        $tcp.Close()
    }
}
Write-Host ""

# تست Ping
Write-Host "📡 === تست پروتکل‌ها ===" -ForegroundColor Yellow
$ping = Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet
if ($ping) {
    Write-Host "✅ ICMP (Ping): WORKS" -ForegroundColor Green
} else {
    Write-Host "❌ ICMP (Ping): BLOCKED" -ForegroundColor Red
}

# DNS Resolution
try {
    $dns = Resolve-DnsName google.com -ErrorAction Stop
    Write-Host "✅ DNS Resolution: WORKS" -ForegroundColor Green
} catch {
    Write-Host "❌ DNS Resolution: FAILED" -ForegroundColor Red
}
Write-Host ""

# تست DNS های معروف
Write-Host "🔗 === تست DNS Servers ===" -ForegroundColor Yellow
$dnsServers = @(
    @{IP="8.8.8.8"; Name="Google-1"},
    @{IP="8.8.4.4"; Name="Google-2"},
    @{IP="1.1.1.1"; Name="Cloudflare-1"},
    @{IP="1.0.0.1"; Name="Cloudflare-2"},
    @{IP="9.9.9.9"; Name="Quad9"},
    @{IP="208.67.222.222"; Name="OpenDNS"}
)

foreach ($dns in $dnsServers) {
    try {
        $result = Resolve-DnsName google.com -Server $dns.IP -ErrorAction Stop -DnsOnly
        Write-Host "✅ $($dns.Name) ($($dns.IP)): WORKS" -ForegroundColor Green
    } catch {
        Write-Host "❌ $($dns.Name) ($($dns.IP)): BLOCKED" -ForegroundColor Red
    }
}
Write-Host ""

# تست سرعت
Write-Host "⚡ === تست سرعت ===" -ForegroundColor Yellow
try {
    $start = Get-Date
    Invoke-WebRequest -Uri "https://speed.cloudflare.com/__down?bytes=1000000" -UseBasicParsing -TimeoutSec 30 -OutFile $null
    $end = Get-Date
    $time = ($end - $start).TotalSeconds
    $speed = [math]::Round(1 / $time, 2)
    Write-Host "📥 Download Speed: ~$speed MB/s" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Speed test failed" -ForegroundColor Red
}
Write-Host ""

# Traceroute
Write-Host "🗺️ === مسیر اتصال (اولین 10 hop) ===" -ForegroundColor Yellow
tracert -h 10 8.8.8.8
Write-Host ""

Write-Host "========================================"
Write-Host "✅ تست کامل شد!" -ForegroundColor Green
Write-Host "========================================"
Write-Host ""
Write-Host "💡 نتایج را کپی کنید و به من بدهید تا تحلیل کنم" -ForegroundColor Cyan

# منتظر ورودی کاربر
Read-Host "Enter را بزنید برای خروج"
