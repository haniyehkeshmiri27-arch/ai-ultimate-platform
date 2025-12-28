#!/bin/bash
# ============================================
# 🚀 Ultimate AI Platform - Complete Setup
# ============================================
set -e

echo "🎯 Starting Ultimate AI Platform Installation..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
else
    OS="windows"
fi

echo -e "${GREEN}Detected OS: $OS${NC}"
echo ""

# ============================================
# STEP 1: System Dependencies
# ============================================
echo -e "${YELLOW}📦 Installing system dependencies...${NC}"

if [ "$OS" = "linux" ]; then
    sudo apt-get update -qq
    sudo apt-get install -y \
        git wget curl \
        python3 python3-pip python3-venv \
        build-essential \
        libgl1 libglib2.0-0 \
        ffmpeg \
        nginx \
        docker.io docker-compose \
        nodejs npm
elif [ "$OS" = "mac" ]; then
    brew install git wget curl python3 ffmpeg nginx docker nodejs
fi

# ============================================
# STEP 2: Python Environment
# ============================================
echo -e "${YELLOW}🐍 Setting up Python environment...${NC}"

cd /workspace 2>/dev/null || cd ~

python3 -m venv ai-env
source ai-env/bin/activate

pip install --upgrade pip
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# ============================================
# STEP 3: ComfyUI
# ============================================
echo -e "${YELLOW}🎨 Installing ComfyUI...${NC}"

if [ ! -d "ComfyUI" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git
fi

cd ComfyUI
pip install -r requirements.txt
pip install xformers

# ComfyUI Manager
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
cd ../..

# ============================================
# STEP 4: Kohya SS
# ============================================
echo -e "${YELLOW}🎓 Installing Kohya SS...${NC}"

if [ ! -d "kohya_ss" ]; then
    git clone https://github.com/bmaltais/kohya_ss.git
fi

cd kohya_ss
bash setup.sh
cd ..

# ============================================
# STEP 5: Model Manager
# ============================================
echo -e "${YELLOW}📥 Installing Model Manager...${NC}"

git clone https://github.com/haniyehkeshmiri27-arch/ai-ultimate-platform.git platform
cd platform

pip install -r requirements.txt

# ============================================
# STEP 6: Cloud CLI Tools
# ============================================
echo -e "${YELLOW}☁️ Installing Cloud CLI tools...${NC}"

# Google Cloud SDK
if ! command -v gcloud &> /dev/null; then
    curl https://sdk.cloud.google.com | bash
    exec -l $SHELL
fi

# AWS CLI
if ! command -v aws &> /dev/null; then
    pip install awscli
fi

# GitHub CLI
if ! command -v gh &> /dev/null; then
    if [ "$OS" = "linux" ]; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh
    elif [ "$OS" = "mac" ]; then
        brew install gh
    fi
fi

# ============================================
# STEP 7: Web Services
# ============================================
echo -e "${YELLOW}🌐 Setting up web services...${NC}"

cd platform/web/backend
pip install -r requirements.txt

cd ../frontend
npm install

cd ../../..

# ============================================
# STEP 8: Configuration
# ============================================
echo -e "${YELLOW}⚙️ Creating configuration files...${NC}"

cat > platform/config/.env << 'EOF'
# Google Cloud
GOOGLE_PROJECT_ID=ultimate-vigil-471521-r4
GOOGLE_APPLICATION_CREDENTIALS=/workspace/gcp-key.json

# AWS
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1

# GitHub
GITHUB_TOKEN=

# API Keys
OPENAI_API_KEY=
GEMINI_API_KEY=

# Database
DATABASE_URL=sqlite:///./platform.db

# Security
SECRET_KEY=$(openssl rand -hex 32)
JWT_SECRET=$(openssl rand -hex 32)
EOF

# ============================================
# STEP 9: Docker Setup
# ============================================
echo -e "${YELLOW}🐳 Setting up Docker containers...${NC}"

cd platform
docker-compose build

# ============================================
# STEP 10: Create Shortcuts
# ============================================
echo -e "${YELLOW}🔗 Creating shortcuts...${NC}"

cat > ~/start-comfyui.sh << 'EOF'
#!/bin/bash
cd /workspace/ComfyUI
python main.py --listen 0.0.0.0 --port 8188
EOF

cat > ~/start-kohya.sh << 'EOF'
#!/bin/bash
cd /workspace/kohya_ss
bash gui.sh --listen 0.0.0.0 --server_port 7860
EOF

cat > ~/start-api.sh << 'EOF'
#!/bin/bash
cd /workspace/platform/web/backend
uvicorn main:app --host 0.0.0.0 --port 5000 --reload
EOF

chmod +x ~/*.sh

# ============================================
# COMPLETION
# ============================================
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✅ Installation Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📋 Quick Start Commands:"
echo ""
echo -e "  🎨 ComfyUI:      ${YELLOW}bash ~/start-comfyui.sh${NC}"
echo -e "  🎓 Kohya SS:     ${YELLOW}bash ~/start-kohya.sh${NC}"
echo -e "  🌐 API Server:   ${YELLOW}bash ~/start-api.sh${NC}"
echo ""
echo -e "📊 Access URLs:"
echo ""
echo -e "  ComfyUI:   ${GREEN}http://localhost:8188${NC}"
echo -e "  Kohya SS:  ${GREEN}http://localhost:7860${NC}"
echo -e "  API:       ${GREEN}http://localhost:5000${NC}"
echo -e "  Docs:      ${GREEN}http://localhost:5000/docs${NC}"
echo ""
echo -e "📖 Documentation: ${GREEN}/workspace/platform/docs/${NC}"
echo ""
echo -e "${YELLOW}⚠️  Don't forget to configure:${NC}"
echo -e "  - Google Cloud credentials"
echo -e "  - AWS credentials"
echo -e "  - GitHub token"
echo -e "  - API keys"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
