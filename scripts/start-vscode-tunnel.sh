#!/bin/bash
# راه‌اندازی VS Code Remote Tunnel برای Runpod

set -e

echo "🚀 Starting VS Code Remote Tunnel..."

# نصب VS Code CLI اگه نصب نیست
if ! command -v code &> /dev/null; then
    echo "📥 Installing VS Code CLI..."
    cd /workspace
    curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz
    tar -xf vscode_cli.tar.gz
    chmod +x code
    mv code /usr/local/bin/
    rm vscode_cli.tar.gz
    echo "✅ VS Code CLI installed"
fi

# چک کردن اگه tunnel در حال اجراست
if pgrep -f "code tunnel" > /dev/null; then
    echo "⚠️  Tunnel is already running!"
    echo "📋 View logs: tail -f /tmp/tunnel.log"
    exit 0
fi

# راه‌اندازی tunnel
echo "🔧 Starting tunnel..."
nohup code tunnel --accept-server-license-terms --name runpod-gpu > /tmp/tunnel.log 2>&1 &

# منتظر بمون تا tunnel آماده شه
sleep 5

# نمایش لاگ
echo ""
echo "📋 Tunnel Logs:"
echo "─────────────────────────────────────────────────────"
cat /tmp/tunnel.log
echo "─────────────────────────────────────────────────────"
echo ""
echo "✅ Tunnel started successfully!"
echo ""
echo "📌 Next steps:"
echo "   1. Go to: https://github.com/login/device"
echo "   2. Enter the code shown above"
echo "   3. In VS Code: Ctrl+Shift+P → 'Remote-Tunnels: Connect to Tunnel'"
echo "   4. Select: runpod-gpu"
echo ""
echo "📊 Monitor logs: tail -f /tmp/tunnel.log"
echo "🛑 Stop tunnel: pkill -f 'code tunnel'"
