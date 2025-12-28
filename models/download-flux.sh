#!/bin/bash
# ============================================
# 📥 Flux.1 Model Downloader
# ============================================
set -e

MODEL_DIR="${MODEL_DIR:-/workspace/ComfyUI/models}"
HUGGINGFACE_TOKEN="${HUGGINGFACE_TOKEN:-}"

echo "📥 Downloading Flux.1 Dev model..."
echo "This will download ~12GB"
echo ""

# Create directories
mkdir -p "$MODEL_DIR/unet"
mkdir -p "$MODEL_DIR/vae"
mkdir -p "$MODEL_DIR/clip"

# Download main model
echo "⬇️  Downloading Flux.1 Dev (12GB)..."
cd "$MODEL_DIR/unet"
if [ ! -f "flux1-dev.safetensors" ]; then
    wget --progress=bar:force:noscroll \
        "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"
else
    echo "✅ flux1-dev.safetensors already exists"
fi

# Download VAE
echo "⬇️  Downloading VAE..."
cd "$MODEL_DIR/vae"
if [ ! -f "ae.safetensors" ]; then
    wget --progress=bar:force:noscroll \
        "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors"
else
    echo "✅ ae.safetensors already exists"
fi

# Download Text Encoders
echo "⬇️  Downloading Text Encoders..."
cd "$MODEL_DIR/clip"
if [ ! -f "clip_l.safetensors" ]; then
    wget --progress=bar:force:noscroll \
        "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
else
    echo "✅ clip_l.safetensors already exists"
fi

if [ ! -f "t5xxl_fp16.safetensors" ]; then
    wget --progress=bar:force:noscroll \
        "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors"
else
    echo "✅ t5xxl_fp16.safetensors already exists"
fi

echo ""
echo "✅ Flux.1 Dev downloaded successfully!"
echo ""
echo "Location:"
echo "  UNet: $MODEL_DIR/unet/flux1-dev.safetensors"
echo "  VAE:  $MODEL_DIR/vae/ae.safetensors"
echo "  CLIP: $MODEL_DIR/clip/clip_l.safetensors"
echo "  T5:   $MODEL_DIR/clip/t5xxl_fp16.safetensors"
