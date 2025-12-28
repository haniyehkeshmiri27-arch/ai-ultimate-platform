#!/bin/bash
# ============================================
# 🌐 Domain & Nginx Setup
# ============================================
set -e

DOMAIN="${1:-}"
EMAIL="${2:-admin@example.com}"

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain> [email]"
    echo "Example: $0 ai.example.com admin@example.com"
    exit 1
fi

echo "🌐 Setting up domain: $DOMAIN"
echo ""

# Install Nginx if not present
if ! command -v nginx &> /dev/null; then
    echo "📦 Installing Nginx..."
    sudo apt-get update -qq
    sudo apt-get install -y nginx
fi

# Install Certbot for SSL
if ! command -v certbot &> /dev/null; then
    echo "🔐 Installing Certbot..."
    sudo apt-get install -y certbot python3-certbot-nginx
fi

# Create Nginx config
echo "⚙️  Creating Nginx configuration..."

sudo tee /etc/nginx/sites-available/$DOMAIN << EOF
# ComfyUI
server {
    listen 80;
    server_name comfyui.$DOMAIN;
    
    location / {
        proxy_pass http://localhost:8188;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # WebSocket support
        proxy_read_timeout 86400;
    }
}

# Kohya SS
server {
    listen 80;
    server_name kohya.$DOMAIN;
    
    location / {
        proxy_pass http://localhost:7860;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}

# API Server
server {
    listen 80;
    server_name api.$DOMAIN;
    
    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

# Web Dashboard
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Enable site
sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

# Test config
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

echo "✅ Nginx configured"
echo ""

# Setup SSL with Let's Encrypt
echo "🔐 Setting up SSL certificates..."

sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN \
    -d comfyui.$DOMAIN -d kohya.$DOMAIN -d api.$DOMAIN \
    --email $EMAIL --agree-tos --non-interactive

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Domain setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "URLs:"
echo "  Dashboard:  https://$DOMAIN"
echo "  ComfyUI:    https://comfyui.$DOMAIN"
echo "  Kohya SS:   https://kohya.$DOMAIN"
echo "  API:        https://api.$DOMAIN"
echo ""
echo "SSL certificates will auto-renew"
