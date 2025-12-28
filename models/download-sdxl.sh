#!/bin/bash
# ============================================
# 📥 SDXL + RealVisXL Model Downloader
# ============================================
set -e

MODEL_DIR="${MODEL_DIR:-/workspace/ComfyUI/models/checkpoints}"
mkdir -p "$MODEL_DIR"

echo "📥 Downloading SDXL models..."
echo ""

# RealVisXL V5.0 (Best for realistic photos)
echo "⬇️  Downloading RealVisXL V5.0 (6.9GB)..."
cd "$MODEL_DIR"
if [ ! -f "realvisxl_v50.safetensors" ]; then
    wget --content-disposition --progress=bar:force:noscroll \
        "https://civitai.com/api/download/models/1017206?type=Model&format=SafeTensor&size=pruned&fp=fp16" \
        -O realvisxl_v50.safetensors
else
    echo "✅ realvisxl_v50.safetensors already exists"
fi

# Juggernaut XL V9
echo "⬇️  Downloading Juggernaut XL V9 (6.5GB)..."
if [ ! -f "juggernautXL_v9.safetensors" ]; then
    wget --content-disposition --progress=bar:force:noscroll \
        "https://civitai.com/api/download/models/456194?type=Model&format=SafeTensor&size=pruned&fp=fp16" \
        -O juggernautXL_v9.safetensors
else
    echo "✅ juggernautXL_v9.safetensors already exists"
fi

echo ""
echo "✅ SDXL models downloaded successfully!"
echo ""
echo "Models:"
echo "  RealVisXL V5:    $MODEL_DIR/realvisxl_v50.safetensors"
echo "  Juggernaut XL:   $MODEL_DIR/juggernautXL_v9.safetensors"
