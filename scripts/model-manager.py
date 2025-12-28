#!/usr/bin/env python3
"""
Model Manager - Download and organize AI models
"""

import os
import sys
import argparse
import requests
from pathlib import Path
from tqdm import tqdm

# Model registry
MODELS = {
    "flux-1-dev": {
        "url": "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors",
        "size": "12GB",
        "type": "unet",
        "description": "Flux.1 Dev - Best realistic images"
    },
    "realvisxl-v5": {
        "url": "https://civitai.com/api/download/models/1017206",
        "size": "6.9GB",
        "type": "checkpoint",
        "description": "RealVisXL V5 - Ultra realistic SDXL"
    },
    "juggernaut-xl": {
        "url": "https://civitai.com/api/download/models/456194",
        "size": "6.5GB",
        "type": "checkpoint",
        "description": "Juggernaut XL V9 - Versatile SDXL"
    }
}

def download_file(url, destination, description=""):
    """Download file with progress bar"""
    response = requests.get(url, stream=True, allow_redirects=True)
    total_size = int(response.headers.get('content-length', 0))
    
    with open(destination, 'wb') as file, tqdm(
        desc=description,
        total=total_size,
        unit='B',
        unit_scale=True,
        unit_divisor=1024,
    ) as progress_bar:
        for data in response.iter_content(chunk_size=8192):
            size = file.write(data)
            progress_bar.update(size)

def list_models():
    """List available models"""
    print("\n📦 Available Models:\n")
    print(f"{'Name':<20} {'Size':<10} {'Type':<15} {'Description'}")
    print("-" * 80)
    
    for name, info in MODELS.items():
        print(f"{name:<20} {info['size']:<10} {info['type']:<15} {info['description']}")
    
    print()

def download_model(model_name, models_dir="/workspace/ComfyUI/models"):
    """Download specific model"""
    if model_name not in MODELS:
        print(f"❌ Model '{model_name}' not found")
        list_models()
        return
    
    model_info = MODELS[model_name]
    model_type = model_info['type']
    
    # Create directory
    target_dir = Path(models_dir) / model_type
    target_dir.mkdir(parents=True, exist_ok=True)
    
    # Destination file
    filename = f"{model_name}.safetensors"
    destination = target_dir / filename
    
    if destination.exists():
        print(f"✅ {model_name} already exists at {destination}")
        return
    
    print(f"\n📥 Downloading {model_name}...")
    print(f"   Size: {model_info['size']}")
    print(f"   Type: {model_type}")
    print()
    
    try:
        download_file(
            model_info['url'],
            destination,
            model_info['description']
        )
        print(f"\n✅ Downloaded: {destination}")
    except Exception as e:
        print(f"\n❌ Error downloading: {e}")
        if destination.exists():
            destination.unlink()

def scan_models(models_dir="/workspace/ComfyUI/models"):
    """Scan and list installed models"""
    models_dir = Path(models_dir)
    
    if not models_dir.exists():
        print(f"❌ Models directory not found: {models_dir}")
        return
    
    print("\n📊 Installed Models:\n")
    
    for model_type in ['checkpoints', 'unet', 'loras', 'vae']:
        type_dir = models_dir / model_type
        if not type_dir.exists():
            continue
        
        files = list(type_dir.glob('*.safetensors')) + list(type_dir.glob('*.ckpt'))
        
        if files:
            print(f"\n{model_type.upper()}:")
            for file in files:
                size = file.stat().st_size / (1024**3)  # GB
                print(f"  • {file.name:<50} {size:>6.2f} GB")
    
    print()

def main():
    parser = argparse.ArgumentParser(
        description="AI Model Manager"
    )
    parser.add_argument(
        'action',
        choices=['list', 'download', 'scan'],
        help='Action to perform'
    )
    parser.add_argument(
        'model',
        nargs='?',
        help='Model name to download'
    )
    parser.add_argument(
        '--models-dir',
        default='/workspace/ComfyUI/models',
        help='Models directory'
    )
    
    args = parser.parse_args()
    
    if args.action == 'list':
        list_models()
    elif args.action == 'scan':
        scan_models(args.models_dir)
    elif args.action == 'download':
        if not args.model:
            print("❌ Model name required for download")
            list_models()
            sys.exit(1)
        download_model(args.model, args.models_dir)

if __name__ == "__main__":
    main()
