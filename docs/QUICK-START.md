# 🚀 Quick Start Guide

## Prerequisites

- Linux/Mac/Windows with WSL2
- Python 3.10+
- GPU with 16GB+ VRAM (RTX 3090/4090/A6000)
- 200GB+ free disk space

---

## Installation

### Option 1: One-Command Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/haniyehkeshmiri27-arch/ai-ultimate-platform/main/setup/install-all.sh | bash
```

### Option 2: Manual Install

```bash
# Clone repository
git clone https://github.com/haniyehkeshmiri27-arch/ai-ultimate-platform.git
cd ai-ultimate-platform

# Run setup
bash setup/install-all.sh
```

---

## First Steps

### 1. Download Models

```bash
# Download Flux.1 (12GB)
bash models/download-flux.sh

# Download SDXL models (14GB)
bash models/download-sdxl.sh
```

### 2. Start Services

```bash
# Start ComfyUI
bash ~/start-comfyui.sh

# Start Kohya SS (in another terminal)
bash ~/start-kohya.sh

# Start API Server (optional)
bash ~/start-api.sh
```

### 3. Access Web Interfaces

- **ComfyUI**: http://localhost:8188
- **Kohya SS**: http://localhost:7860
- **API Docs**: http://localhost:5000/docs

---

## Quick Tasks

### Generate an Image

1. Open ComfyUI: http://localhost:8188
2. Load workflow: `workflows/comfyui/realistic-photo.json`
3. Enter prompt: "realistic photo of a person"
4. Click "Queue Prompt"

### Train a LoRA

1. Prepare 20-50 images in `/workspace/training/input/10_subject/`
2. Open Kohya SS: http://localhost:7860
3. Load config: `training/lora/flux-lora-config.toml`
4. Click "Start Training"

### Sync with Google Cloud

```bash
# Upload to GCS
bash sync/gcs-sync.sh upload

# Download from GCS
bash sync/gcs-sync.sh download

# Auto-sync every 30 minutes
bash sync/gcs-sync.sh auto
```

---

## Configuration

### Google Cloud Setup

```bash
# Install gcloud SDK
curl https://sdk.cloud.google.com | bash

# Authenticate
gcloud auth login
gcloud auth application-default login

# Set project
gcloud config set project ultimate-vigil-471521-r4
```

### Environment Variables

Edit `config/.env`:

```bash
# Google Cloud
GOOGLE_PROJECT_ID=your-project-id
GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json

# AWS (optional)
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret

# GitHub
GITHUB_TOKEN=ghp_xxxxx

# Storage
GCS_BUCKET=gs://your-bucket
```

---

## Common Commands

```bash
# Check GPU
nvidia-smi

# List models
ls /workspace/ComfyUI/models/checkpoints

# View logs
tail -f /workspace/training/logs/*.log

# Stop all services
pkill -f "python.*ComfyUI"
pkill -f "python.*kohya"
```

---

## Troubleshooting

### Out of Memory

```bash
# Reduce batch size in training config
train_batch_size = 1
gradient_accumulation_steps = 2
```

### Slow Generation

```bash
# Enable xformers
pip install xformers
```

### Models not loading

```bash
# Check paths
ls -lh /workspace/ComfyUI/models/
```

---

## Next Steps

- [Training Guide](TRAINING-GUIDE.md)
- [Cloud Deployment](CLOUD-DEPLOYMENT.md)
- [Domain Setup](DOMAIN-SETUP.md)
- [API Reference](API-REFERENCE.md)

---

**Need help? Check [Troubleshooting](TROUBLESHOOTING.md)**
