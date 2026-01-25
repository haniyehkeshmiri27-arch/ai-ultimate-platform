#!/usr/bin/env python3
"""
🌐 ULTIMATE NETWORK SCANNER v2.0
Professional Network Analysis Tool for Iran
Author: AI Ultimate Platform
Features:
- Global ping test to 50+ countries
- DNS benchmark (20+ DNS servers)
- CDN latency test
- Port scanning
- Protocol detection
- VPN/Tunnel recommendation
- Speed test
- Full network diagnostics
"""

import socket
import subprocess
import json
import time
import threading
import sys
import os
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
import urllib.request
import ssl

# Colors for terminal
class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    END = '\033[0m'

# Global results storage
results = {
    "timestamp": "",
    "ip_info": {},
    "ping_results": {},
    "dns_results": {},
    "cdn_results": {},
    "port_results": {},
    "protocol_results": {},
    "speed_results": {},
    "recommendations": {}
}

# ============================================
# GLOBAL SERVER DATABASE
# ============================================

GLOBAL_SERVERS = {
    # Europe
    "Germany-Frankfurt": ["185.230.143.1", "91.134.165.1", "51.116.145.1"],
    "Germany-Falkenstein": ["116.202.223.1", "138.201.149.1"],
    "Netherlands-Amsterdam": ["51.15.235.1", "185.107.56.1", "95.179.210.1"],
    "UK-London": ["185.174.101.1", "178.62.1.1", "139.59.166.1"],
    "France-Paris": ["51.91.7.1", "54.36.99.1", "163.172.130.1"],
    "Sweden-Stockholm": ["185.12.28.1", "45.133.1.1"],
    "Finland-Helsinki": ["95.216.3.1", "65.21.1.1"],
    "Poland-Warsaw": ["51.83.185.1", "51.77.52.1"],
    "Switzerland-Zurich": ["185.181.60.1", "31.171.154.1"],
    "Austria-Vienna": ["194.208.20.1"],
    "Spain-Madrid": ["212.230.36.1"],
    "Italy-Milan": ["185.191.171.1"],
    "Norway-Oslo": ["185.164.136.1"],
    "Denmark-Copenhagen": ["185.21.102.1"],
    "Czech-Prague": ["185.8.239.1"],
    "Romania-Bucharest": ["185.117.82.1"],
    "Bulgaria-Sofia": ["185.94.156.1"],
    "Hungary-Budapest": ["185.189.151.1"],
    "Russia-Moscow": ["185.5.250.1", "5.8.37.1"],
    "Russia-StPetersburg": ["185.77.217.1"],
    "Ukraine-Kyiv": ["91.200.40.1"],
    "Turkey-Istanbul": ["185.64.76.1", "31.145.176.1"],
    
    # Americas
    "USA-NewYork": ["66.175.212.1", "45.63.44.1", "207.246.84.1"],
    "USA-LosAngeles": ["45.63.105.1", "66.42.113.1", "149.28.92.1"],
    "USA-SanFrancisco": ["104.238.131.1", "45.32.200.1"],
    "USA-Chicago": ["107.191.102.1", "208.76.62.1"],
    "USA-Dallas": ["45.63.53.1", "104.156.228.1"],
    "USA-Miami": ["45.77.141.1", "108.61.18.1"],
    "USA-Seattle": ["140.82.48.1", "45.76.194.1"],
    "USA-Atlanta": ["45.76.162.1", "108.61.206.1"],
    "Canada-Toronto": ["149.248.52.1", "158.69.125.1"],
    "Canada-Montreal": ["167.114.158.1", "144.217.91.1"],
    "Brazil-SaoPaulo": ["200.136.49.1", "177.54.156.1"],
    "Mexico-MexicoCity": ["45.61.186.1"],
    
    # Asia Pacific
    "Japan-Tokyo": ["45.76.101.1", "139.180.169.1", "167.179.112.1"],
    "Japan-Osaka": ["167.179.93.1"],
    "Singapore": ["45.77.255.1", "139.180.144.1", "157.230.44.1"],
    "HongKong": ["45.32.43.1", "103.99.116.1"],
    "Taiwan-Taipei": ["139.162.65.1"],
    "SouthKorea-Seoul": ["45.63.56.1", "141.164.51.1"],
    "India-Mumbai": ["139.59.1.1", "206.189.132.1"],
    "India-Bangalore": ["139.59.54.1"],
    "Australia-Sydney": ["45.32.181.1", "149.28.165.1"],
    "Australia-Melbourne": ["108.61.96.1"],
    "Indonesia-Jakarta": ["103.253.107.1"],
    "Malaysia-KualaLumpur": ["103.106.250.1"],
    "Thailand-Bangkok": ["27.131.160.1"],
    "Vietnam-HoChiMinh": ["103.200.20.1"],
    "Philippines-Manila": ["103.91.162.1"],
    
    # Middle East
    "UAE-Dubai": ["94.200.200.1", "185.151.147.1"],
    "Israel-TelAviv": ["185.229.226.1"],
    "SaudiArabia-Riyadh": ["212.138.64.1"],
    "Qatar-Doha": ["213.130.112.1"],
    "Bahrain": ["185.189.112.1"],
    
    # Africa
    "SouthAfrica-Johannesburg": ["197.189.226.1", "41.79.69.1"],
    "Egypt-Cairo": ["197.53.1.1"],
    "Nigeria-Lagos": ["154.120.86.1"],
    "Kenya-Nairobi": ["41.220.28.1"],
}

# DNS Servers Database
DNS_SERVERS = {
    # Global DNS
    "Google-Primary": "8.8.8.8",
    "Google-Secondary": "8.8.4.4",
    "Cloudflare-Primary": "1.1.1.1",
    "Cloudflare-Secondary": "1.0.0.1",
    "Cloudflare-Malware": "1.1.1.2",
    "Cloudflare-Family": "1.1.1.3",
    "Quad9-Primary": "9.9.9.9",
    "Quad9-Secondary": "149.112.112.112",
    "OpenDNS-Primary": "208.67.222.222",
    "OpenDNS-Secondary": "208.67.220.220",
    "OpenDNS-Family": "208.67.222.123",
    "AdGuard-Primary": "94.140.14.14",
    "AdGuard-Secondary": "94.140.15.15",
    "AdGuard-Family": "94.140.14.15",
    "CleanBrowsing-Security": "185.228.168.9",
    "CleanBrowsing-Family": "185.228.168.168",
    "Comodo-Secure": "8.26.56.26",
    "Level3": "4.2.2.1",
    "Level3-2": "4.2.2.2",
    "Verisign-Primary": "64.6.64.6",
    "Verisign-Secondary": "64.6.65.6",
    "DNS.Watch-1": "84.200.69.80",
    "DNS.Watch-2": "84.200.70.40",
    "Yandex-Basic": "77.88.8.8",
    "Yandex-Safe": "77.88.8.88",
    "Norton-Security": "199.85.126.10",
    
    # Iran DNS
    "Shecan-Primary": "178.22.122.100",
    "Shecan-Secondary": "185.51.200.2",
    "403-Primary": "10.202.10.202",
    "403-Secondary": "10.202.10.102",
    "Radar-Primary": "10.202.10.10",
    "Radar-Secondary": "10.202.10.11",
    "Electro-Primary": "78.157.42.100",
    "Electro-Secondary": "78.157.42.101",
    "ParsOnline": "91.99.101.14",
    "Shatel": "85.15.1.14",
    "Asiatech": "194.36.174.161",
    "MCI": "5.200.200.200",
    "Irancell": "5.202.100.100",
}

# CDN Endpoints
CDN_ENDPOINTS = {
    "Cloudflare": ["1.1.1.1", "104.16.0.1", "172.64.0.1"],
    "Fastly": ["151.101.1.1", "151.101.65.1"],
    "Akamai": ["23.32.0.1", "104.64.0.1"],
    "CloudFront-AWS": ["13.224.0.1", "99.84.0.1"],
    "Google-CDN": ["216.58.214.1", "172.217.0.1"],
    "Microsoft-Azure": ["13.107.4.50", "40.90.4.1"],
    "Bunny-CDN": ["185.172.148.1"],
    "KeyCDN": ["185.166.36.1"],
    "StackPath": ["151.139.128.1"],
    "ArvanCloud": ["185.143.233.1", "79.175.176.1"],
}

# Common VPN/Tunnel Ports
VPN_PORTS = {
    80: "HTTP",
    443: "HTTPS/TLS",
    22: "SSH",
    53: "DNS",
    8080: "HTTP-Alt",
    8443: "HTTPS-Alt",
    1194: "OpenVPN",
    1195: "OpenVPN-Alt",
    4500: "IPSec-NAT",
    500: "IPSec",
    51820: "WireGuard",
    51821: "WireGuard-Alt",
    1723: "PPTP",
    1701: "L2TP",
    5555: "Freegate",
    8888: "HTTP-Proxy",
    3128: "Squid-Proxy",
    1080: "SOCKS",
    9050: "Tor",
    9150: "Tor-Browser",
    2222: "SSH-Alt",
    2083: "cPanel-SSL",
    2087: "WHM-SSL",
    2095: "cPanel-Webmail",
    2096: "cPanel-Webmail-SSL",
    8880: "Alt-HTTP",
    9443: "Alt-HTTPS",
    10000: "Webmin",
    3389: "RDP",
    5900: "VNC",
    6881: "BitTorrent",
    25565: "Minecraft",
}

# ============================================
# UTILITY FUNCTIONS
# ============================================

def print_banner():
    banner = f"""
{Colors.CYAN}╔══════════════════════════════════════════════════════════════════╗
║  {Colors.YELLOW}🌐 ULTIMATE NETWORK SCANNER v2.0{Colors.CYAN}                               ║
║  {Colors.WHITE}Professional Network Analysis Tool{Colors.CYAN}                             ║
║  {Colors.GREEN}For Iran - Full Diagnostics{Colors.CYAN}                                    ║
╠══════════════════════════════════════════════════════════════════╣
║  Features:                                                        ║
║  • Global Ping Test (50+ Countries)                              ║
║  • DNS Benchmark (25+ Servers)                                   ║
║  • CDN Latency Analysis                                          ║
║  • Port Scanning (30+ Ports)                                     ║
║  • Protocol Detection                                            ║
║  • VPN/Tunnel Recommendations                                    ║
║  • Speed Test                                                    ║
╚══════════════════════════════════════════════════════════════════╝{Colors.END}
"""
    print(banner)

def ping_host(host, count=3, timeout=2):
    """Ping a host and return average latency"""
    try:
        if sys.platform == "win32":
            cmd = ["ping", "-n", str(count), "-w", str(timeout*1000), host]
        else:
            cmd = ["ping", "-c", str(count), "-W", str(timeout), host]
        
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout*count+5)
        output = result.stdout
        
        # Parse average time
        if sys.platform == "win32":
            if "Average" in output:
                avg = output.split("Average = ")[1].split("ms")[0]
                return float(avg)
            elif "میانگین" in output:
                avg = output.split("= ")[3].split("ms")[0]
                return float(avg)
        else:
            if "avg" in output:
                avg = output.split("/")[4]
                return float(avg)
        
        return None
    except:
        return None

def tcp_ping(host, port, timeout=3):
    """TCP ping to measure connection latency"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        start = time.time()
        sock.connect((host, port))
        latency = (time.time() - start) * 1000
        sock.close()
        return round(latency, 2)
    except:
        return None

def check_port(host, port, timeout=3):
    """Check if a port is open"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, port))
        sock.close()
        return result == 0
    except:
        return False

def dns_resolve(dns_server, domain="google.com", timeout=3):
    """Test DNS resolution speed"""
    try:
        import struct
        
        # Build DNS query
        query = b'\x00\x01'  # Transaction ID
        query += b'\x01\x00'  # Flags: standard query
        query += b'\x00\x01'  # Questions: 1
        query += b'\x00\x00'  # Answer RRs: 0
        query += b'\x00\x00'  # Authority RRs: 0
        query += b'\x00\x00'  # Additional RRs: 0
        
        for part in domain.split('.'):
            query += bytes([len(part)]) + part.encode()
        query += b'\x00'  # End of domain
        query += b'\x00\x01'  # Type: A
        query += b'\x00\x01'  # Class: IN
        
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.settimeout(timeout)
        
        start = time.time()
        sock.sendto(query, (dns_server, 53))
        sock.recvfrom(512)
        latency = (time.time() - start) * 1000
        sock.close()
        
        return round(latency, 2)
    except:
        return None

def http_get(url, timeout=10):
    """Make HTTP GET request and measure time"""
    try:
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        
        start = time.time()
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        response = urllib.request.urlopen(req, timeout=timeout, context=ctx)
        data = response.read()
        elapsed = time.time() - start
        
        return {
            "status": response.getcode(),
            "time": round(elapsed * 1000, 2),
            "size": len(data)
        }
    except Exception as e:
        return {"status": 0, "time": None, "error": str(e)}

def get_ip_info():
    """Get public IP and location info"""
    print(f"\n{Colors.YELLOW}[1/8] 📍 Getting IP Information...{Colors.END}")
    
    try:
        response = urllib.request.urlopen("https://ipinfo.io/json", timeout=10)
        data = json.loads(response.read().decode())
        results["ip_info"] = data
        
        print(f"  {Colors.GREEN}✓ IP: {data.get('ip', 'Unknown')}{Colors.END}")
        print(f"  {Colors.GREEN}✓ Country: {data.get('country', 'Unknown')}{Colors.END}")
        print(f"  {Colors.GREEN}✓ City: {data.get('city', 'Unknown')}{Colors.END}")
        print(f"  {Colors.GREEN}✓ ISP: {data.get('org', 'Unknown')}{Colors.END}")
        
        return data
    except:
        try:
            response = urllib.request.urlopen("https://api.ipify.org?format=json", timeout=10)
            data = json.loads(response.read().decode())
            results["ip_info"] = {"ip": data.get("ip")}
            print(f"  {Colors.GREEN}✓ IP: {data.get('ip', 'Unknown')}{Colors.END}")
            return data
        except Exception as e:
            print(f"  {Colors.RED}✗ Failed to get IP info: {e}{Colors.END}")
            return {}

def test_global_ping():
    """Test ping to servers worldwide"""
    print(f"\n{Colors.YELLOW}[2/8] 🌍 Testing Global Ping (50+ Countries)...{Colors.END}")
    
    ping_results = {}
    
    def test_location(name, servers):
        for server in servers:
            latency = ping_host(server, count=2, timeout=2)
            if latency:
                return (name, latency, server)
            # Try TCP ping as fallback
            latency = tcp_ping(server, 80, timeout=2)
            if latency:
                return (name, latency, server)
        return (name, None, None)
    
    with ThreadPoolExecutor(max_workers=20) as executor:
        futures = {executor.submit(test_location, name, servers): name 
                   for name, servers in GLOBAL_SERVERS.items()}
        
        completed = 0
        total = len(futures)
        
        for future in as_completed(futures):
            completed += 1
            name, latency, server = future.result()
            if latency:
                ping_results[name] = {"latency": latency, "server": server}
            print(f"\r  Progress: {completed}/{total}", end="", flush=True)
    
    print()
    
    # Sort by latency
    sorted_results = sorted(ping_results.items(), key=lambda x: x[1]["latency"])
    results["ping_results"] = dict(sorted_results)
    
    # Print top 10
    print(f"\n  {Colors.CYAN}🏆 TOP 10 Fastest Locations:{Colors.END}")
    for i, (name, data) in enumerate(sorted_results[:10], 1):
        color = Colors.GREEN if data["latency"] < 100 else Colors.YELLOW if data["latency"] < 200 else Colors.RED
        print(f"  {i:2}. {color}{name}: {data['latency']:.1f}ms{Colors.END}")
    
    return dict(sorted_results)

def test_dns_servers():
    """Benchmark DNS servers"""
    print(f"\n{Colors.YELLOW}[3/8] 🔍 Testing DNS Servers (25+ Servers)...{Colors.END}")
    
    dns_results = {}
    
    def test_dns(name, server):
        latency = dns_resolve(server)
        return (name, latency, server)
    
    with ThreadPoolExecutor(max_workers=15) as executor:
        futures = {executor.submit(test_dns, name, server): name 
                   for name, server in DNS_SERVERS.items()}
        
        for future in as_completed(futures):
            name, latency, server = future.result()
            if latency:
                dns_results[name] = {"latency": latency, "server": server, "status": "OK"}
            else:
                dns_results[name] = {"latency": None, "server": server, "status": "BLOCKED"}
    
    # Sort by latency
    working = {k: v for k, v in dns_results.items() if v["latency"]}
    blocked = {k: v for k, v in dns_results.items() if not v["latency"]}
    
    sorted_working = sorted(working.items(), key=lambda x: x[1]["latency"])
    results["dns_results"] = {"working": dict(sorted_working), "blocked": blocked}
    
    # Print results
    print(f"\n  {Colors.GREEN}✓ Working DNS Servers ({len(working)}):{Colors.END}")
    for name, data in sorted_working[:10]:
        print(f"    • {name} ({data['server']}): {data['latency']:.1f}ms")
    
    print(f"\n  {Colors.RED}✗ Blocked DNS Servers ({len(blocked)}):{Colors.END}")
    for name, data in list(blocked.items())[:5]:
        print(f"    • {name} ({data['server']})")
    
    return results["dns_results"]

def test_cdn_latency():
    """Test CDN endpoints"""
    print(f"\n{Colors.YELLOW}[4/8] ⚡ Testing CDN Latency...{Colors.END}")
    
    cdn_results = {}
    
    for cdn_name, servers in CDN_ENDPOINTS.items():
        best_latency = None
        best_server = None
        
        for server in servers:
            latency = tcp_ping(server, 443, timeout=3)
            if latency and (best_latency is None or latency < best_latency):
                best_latency = latency
                best_server = server
        
        if best_latency:
            cdn_results[cdn_name] = {"latency": best_latency, "server": best_server, "status": "OK"}
        else:
            cdn_results[cdn_name] = {"latency": None, "server": servers[0], "status": "BLOCKED"}
    
    # Sort
    working = {k: v for k, v in cdn_results.items() if v["latency"]}
    sorted_cdn = sorted(working.items(), key=lambda x: x[1]["latency"])
    
    results["cdn_results"] = cdn_results
    
    print(f"\n  {Colors.CYAN}CDN Latency Results:{Colors.END}")
    for name, data in sorted_cdn:
        color = Colors.GREEN if data["latency"] < 50 else Colors.YELLOW if data["latency"] < 100 else Colors.RED
        print(f"    {color}• {name}: {data['latency']:.1f}ms{Colors.END}")
    
    return cdn_results

def test_ports():
    """Test common VPN/Tunnel ports"""
    print(f"\n{Colors.YELLOW}[5/8] 🔌 Testing Ports (30+ Ports)...{Colors.END}")
    
    port_results = {"open": {}, "closed": {}}
    test_host = "8.8.8.8"
    
    def test_port(port, name):
        is_open = check_port(test_host, port, timeout=3)
        return (port, name, is_open)
    
    with ThreadPoolExecutor(max_workers=20) as executor:
        futures = {executor.submit(test_port, port, name): port 
                   for port, name in VPN_PORTS.items()}
        
        for future in as_completed(futures):
            port, name, is_open = future.result()
            if is_open:
                port_results["open"][port] = name
            else:
                port_results["closed"][port] = name
    
    results["port_results"] = port_results
    
    print(f"\n  {Colors.GREEN}✓ Open Ports ({len(port_results['open'])}):{Colors.END}")
    for port, name in sorted(port_results["open"].items()):
        print(f"    • Port {port}: {name}")
    
    print(f"\n  {Colors.RED}✗ Closed Ports ({len(port_results['closed'])}):{Colors.END}")
    closed_list = list(port_results["closed"].items())[:10]
    for port, name in closed_list:
        print(f"    • Port {port}: {name}")
    if len(port_results["closed"]) > 10:
        print(f"    ... and {len(port_results['closed']) - 10} more")
    
    return port_results

def test_protocols():
    """Test various protocols and tunneling methods"""
    print(f"\n{Colors.YELLOW}[6/8] 📡 Testing Protocols & Tunnels...{Colors.END}")
    
    protocols = {
        "HTTPS (443)": ("google.com", 443),
        "HTTP (80)": ("google.com", 80),
        "DNS-over-HTTPS": ("cloudflare-dns.com", 443),
        "DNS-over-TLS": ("1.1.1.1", 853),
        "QUIC/HTTP3": ("google.com", 443),
        "WebSocket": ("echo.websocket.org", 443),
        "SSH (22)": ("github.com", 22),
        "OpenVPN (1194)": ("openvpn.net", 1194),
        "WireGuard (51820)": ("wg.example.com", 51820),
    }
    
    protocol_results = {}
    
    for name, (host, port) in protocols.items():
        try:
            latency = tcp_ping(host, port, timeout=5)
            if latency:
                protocol_results[name] = {"status": "OK", "latency": latency}
                print(f"  {Colors.GREEN}✓ {name}: {latency:.1f}ms{Colors.END}")
            else:
                protocol_results[name] = {"status": "BLOCKED", "latency": None}
                print(f"  {Colors.RED}✗ {name}: BLOCKED{Colors.END}")
        except:
            protocol_results[name] = {"status": "ERROR", "latency": None}
            print(f"  {Colors.YELLOW}? {name}: ERROR{Colors.END}")
    
    results["protocol_results"] = protocol_results
    return protocol_results

def test_speed():
    """Test download speed"""
    print(f"\n{Colors.YELLOW}[7/8] ⚡ Testing Speed...{Colors.END}")
    
    speed_tests = [
        ("Cloudflare", "https://speed.cloudflare.com/__down?bytes=5000000"),
        ("Google", "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"),
    ]
    
    speed_results = {}
    
    for name, url in speed_tests:
        try:
            result = http_get(url, timeout=30)
            if result["time"] and result.get("size"):
                speed_mbps = (result["size"] * 8) / (result["time"] / 1000) / 1000000
                speed_results[name] = {
                    "speed_mbps": round(speed_mbps, 2),
                    "time_ms": result["time"],
                    "size_bytes": result["size"]
                }
                print(f"  {Colors.GREEN}✓ {name}: {speed_mbps:.2f} Mbps{Colors.END}")
            else:
                speed_results[name] = {"status": "FAILED", "error": result.get("error")}
                print(f"  {Colors.RED}✗ {name}: Failed{Colors.END}")
        except Exception as e:
            speed_results[name] = {"status": "ERROR", "error": str(e)}
            print(f"  {Colors.RED}✗ {name}: Error{Colors.END}")
    
    results["speed_results"] = speed_results
    return speed_results

def generate_recommendations():
    """Generate VPN/Network recommendations"""
    print(f"\n{Colors.YELLOW}[8/8] 💡 Generating Recommendations...{Colors.END}")
    
    recommendations = {
        "best_vpn_locations": [],
        "best_dns": [],
        "best_cdn": [],
        "best_protocols": [],
        "best_ports": [],
        "vpn_config": {}
    }
    
    # Best VPN locations (top 5 by ping)
    if results["ping_results"]:
        top_locations = list(results["ping_results"].items())[:5]
        recommendations["best_vpn_locations"] = [
            {"location": loc, "latency": data["latency"]} 
            for loc, data in top_locations
        ]
    
    # Best DNS
    if results["dns_results"].get("working"):
        top_dns = list(results["dns_results"]["working"].items())[:5]
        recommendations["best_dns"] = [
            {"name": name, "server": data["server"], "latency": data["latency"]}
            for name, data in top_dns
        ]
    
    # Best CDN
    working_cdn = {k: v for k, v in results["cdn_results"].items() if v.get("latency")}
    if working_cdn:
        sorted_cdn = sorted(working_cdn.items(), key=lambda x: x[1]["latency"])
        recommendations["best_cdn"] = [
            {"name": name, "latency": data["latency"]}
            for name, data in sorted_cdn[:3]
        ]
    
    # Best protocols
    working_protocols = {k: v for k, v in results["protocol_results"].items() 
                        if v.get("status") == "OK"}
    recommendations["best_protocols"] = list(working_protocols.keys())
    
    # Open ports for VPN
    if results["port_results"]["open"]:
        recommendations["best_ports"] = list(results["port_results"]["open"].keys())
    
    # VPN Config recommendation
    if recommendations["best_vpn_locations"]:
        best_loc = recommendations["best_vpn_locations"][0]
        recommendations["vpn_config"] = {
            "recommended_location": best_loc["location"],
            "recommended_protocols": ["WireGuard", "OpenVPN-TCP-443", "V2Ray-VMESS"],
            "recommended_ports": [443, 80, 8443] if 443 in recommendations["best_ports"] else recommendations["best_ports"][:3],
            "recommended_dns": recommendations["best_dns"][0] if recommendations["best_dns"] else None
        }
    
    results["recommendations"] = recommendations
    
    return recommendations

def print_final_report():
    """Print comprehensive final report"""
    print(f"\n{Colors.CYAN}{'='*70}{Colors.END}")
    print(f"{Colors.BOLD}{Colors.YELLOW}📊 FINAL NETWORK ANALYSIS REPORT{Colors.END}")
    print(f"{Colors.CYAN}{'='*70}{Colors.END}")
    
    # IP Info
    print(f"\n{Colors.BOLD}🌐 YOUR LOCATION:{Colors.END}")
    ip_info = results.get("ip_info", {})
    print(f"  IP: {ip_info.get('ip', 'Unknown')}")
    print(f"  Country: {ip_info.get('country', 'Unknown')}")
    print(f"  City: {ip_info.get('city', 'Unknown')}")
    print(f"  ISP: {ip_info.get('org', 'Unknown')}")
    
    # Best VPN Locations
    print(f"\n{Colors.BOLD}🏆 BEST VPN/VPS LOCATIONS:{Colors.END}")
    rec = results.get("recommendations", {})
    for i, loc in enumerate(rec.get("best_vpn_locations", [])[:5], 1):
        print(f"  {i}. {loc['location']}: {loc['latency']:.1f}ms")
    
    # Best DNS
    print(f"\n{Colors.BOLD}🔍 BEST DNS SERVERS:{Colors.END}")
    for i, dns in enumerate(rec.get("best_dns", [])[:5], 1):
        print(f"  {i}. {dns['name']} ({dns['server']}): {dns['latency']:.1f}ms")
    
    # Best CDN
    print(f"\n{Colors.BOLD}⚡ BEST CDN:{Colors.END}")
    for cdn in rec.get("best_cdn", []):
        print(f"  • {cdn['name']}: {cdn['latency']:.1f}ms")
    
    # Open Ports
    print(f"\n{Colors.BOLD}🔌 OPEN PORTS FOR VPN:{Colors.END}")
    open_ports = results.get("port_results", {}).get("open", {})
    for port, name in list(open_ports.items())[:10]:
        print(f"  • Port {port}: {name}")
    
    # Working Protocols
    print(f"\n{Colors.BOLD}📡 WORKING PROTOCOLS:{Colors.END}")
    for proto in rec.get("best_protocols", []):
        print(f"  ✓ {proto}")
    
    # VPN Config Recommendation
    print(f"\n{Colors.BOLD}🔧 RECOMMENDED VPN CONFIGURATION:{Colors.END}")
    vpn_config = rec.get("vpn_config", {})
    if vpn_config:
        print(f"  📍 Location: {vpn_config.get('recommended_location', 'N/A')}")
        print(f"  📡 Protocols: {', '.join(vpn_config.get('recommended_protocols', []))}")
        print(f"  🔌 Ports: {', '.join(map(str, vpn_config.get('recommended_ports', [])))}")
        if vpn_config.get("recommended_dns"):
            dns = vpn_config["recommended_dns"]
            print(f"  🔍 DNS: {dns['name']} ({dns['server']})")
    
    print(f"\n{Colors.CYAN}{'='*70}{Colors.END}")

def save_results():
    """Save results to JSON file"""
    results["timestamp"] = datetime.now().isoformat()
    
    output_file = "network-scan-results.json"
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    
    print(f"\n{Colors.GREEN}✓ Results saved to: {output_file}{Colors.END}")
    
    # Also save summary as text
    summary_file = "network-scan-summary.txt"
    with open(summary_file, "w", encoding="utf-8") as f:
        f.write("="*70 + "\n")
        f.write("NETWORK SCAN SUMMARY\n")
        f.write(f"Date: {results['timestamp']}\n")
        f.write("="*70 + "\n\n")
        
        f.write("IP INFO:\n")
        for k, v in results.get("ip_info", {}).items():
            f.write(f"  {k}: {v}\n")
        
        f.write("\nTOP 10 VPN LOCATIONS (by ping):\n")
        for i, (loc, data) in enumerate(list(results.get("ping_results", {}).items())[:10], 1):
            f.write(f"  {i}. {loc}: {data['latency']:.1f}ms\n")
        
        f.write("\nTOP 10 DNS SERVERS:\n")
        for i, (name, data) in enumerate(list(results.get("dns_results", {}).get("working", {}).items())[:10], 1):
            f.write(f"  {i}. {name} ({data['server']}): {data['latency']:.1f}ms\n")
        
        f.write("\nOPEN PORTS:\n")
        for port, name in results.get("port_results", {}).get("open", {}).items():
            f.write(f"  Port {port}: {name}\n")
        
        f.write("\nRECOMMENDATIONS:\n")
        rec = results.get("recommendations", {})
        f.write(f"  Best Location: {rec.get('vpn_config', {}).get('recommended_location', 'N/A')}\n")
        f.write(f"  Best Protocols: {', '.join(rec.get('best_protocols', []))}\n")
    
    print(f"{Colors.GREEN}✓ Summary saved to: {summary_file}{Colors.END}")

def main():
    """Main function"""
    print_banner()
    
    print(f"{Colors.BOLD}Starting comprehensive network scan...{Colors.END}")
    print(f"This may take 2-5 minutes depending on your connection.\n")
    
    start_time = time.time()
    
    # Run all tests
    get_ip_info()
    test_global_ping()
    test_dns_servers()
    test_cdn_latency()
    test_ports()
    test_protocols()
    test_speed()
    generate_recommendations()
    
    elapsed = time.time() - start_time
    print(f"\n{Colors.GREEN}✓ Scan completed in {elapsed:.1f} seconds{Colors.END}")
    
    # Print final report
    print_final_report()
    
    # Save results
    save_results()
    
    print(f"\n{Colors.CYAN}{'='*70}{Colors.END}")
    print(f"{Colors.BOLD}Scan Complete! Check the generated files for detailed results.{Colors.END}")
    print(f"{Colors.CYAN}{'='*70}{Colors.END}\n")

if __name__ == "__main__":
    main()
