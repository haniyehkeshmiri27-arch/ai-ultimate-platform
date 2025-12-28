from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import subprocess
import os
from typing import Optional, List
import json

app = FastAPI(
    title="AI Ultimate Platform API",
    description="Comprehensive API for AI image generation, training, and management",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Models
class ImageGenerationRequest(BaseModel):
    prompt: str
    negative_prompt: Optional[str] = ""
    width: int = 1024
    height: int = 1024
    steps: int = 30
    cfg_scale: float = 7.0
    model: str = "flux-1-dev"

class TrainingRequest(BaseModel):
    name: str
    dataset_path: str
    model_type: str = "lora"
    base_model: str = "flux-1-dev"
    steps: int = 2500
    learning_rate: float = 0.0001

class ModelInfo(BaseModel):
    name: str
    type: str
    size: str
    path: str

# Endpoints
@app.get("/")
async def root():
    return {
        "name": "AI Ultimate Platform API",
        "version": "1.0.0",
        "status": "running"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    gpu_available = os.path.exists("/usr/bin/nvidia-smi")
    
    gpu_info = None
    if gpu_available:
        try:
            result = subprocess.run(
                ["nvidia-smi", "--query-gpu=name,memory.total,memory.used", "--format=csv,noheader"],
                capture_output=True,
                text=True
            )
            gpu_info = result.stdout.strip()
        except:
            pass
    
    return {
        "status": "healthy",
        "gpu_available": gpu_available,
        "gpu_info": gpu_info
    }

@app.post("/generate/image")
async def generate_image(request: ImageGenerationRequest, background_tasks: BackgroundTasks):
    """Generate image using ComfyUI"""
    # This would integrate with ComfyUI API
    return {
        "status": "queued",
        "message": "Image generation started",
        "request_id": "img_123",
        "estimated_time": 30
    }

@app.post("/train/lora")
async def train_lora(request: TrainingRequest, background_tasks: BackgroundTasks):
    """Start LoRA training"""
    # This would start Kohya SS training
    return {
        "status": "started",
        "training_id": "train_123",
        "estimated_time": 3600
    }

@app.get("/models/list")
async def list_models():
    """List available models"""
    models_dir = "/workspace/ComfyUI/models/checkpoints"
    models = []
    
    if os.path.exists(models_dir):
        for file in os.listdir(models_dir):
            if file.endswith(('.safetensors', '.ckpt')):
                size = os.path.getsize(os.path.join(models_dir, file))
                models.append({
                    "name": file,
                    "type": "checkpoint",
                    "size": f"{size / (1024**3):.2f} GB",
                    "path": os.path.join(models_dir, file)
                })
    
    return {"models": models}

@app.post("/cloud/sync")
async def sync_cloud(action: str = "upload"):
    """Sync with cloud storage"""
    if action == "upload":
        # Run GCS sync script
        result = subprocess.run(
            ["bash", "/workspace/platform/sync/gcs-sync.sh", "upload"],
            capture_output=True,
            text=True
        )
        return {"status": "success", "action": "upload", "output": result.stdout}
    elif action == "download":
        result = subprocess.run(
            ["bash", "/workspace/platform/sync/gcs-sync.sh", "download"],
            capture_output=True,
            text=True
        )
        return {"status": "success", "action": "download", "output": result.stdout}
    else:
        raise HTTPException(status_code=400, detail="Invalid action")

@app.get("/training/status/{training_id}")
async def get_training_status(training_id: str):
    """Get training status"""
    # Would check actual training status
    return {
        "training_id": training_id,
        "status": "running",
        "progress": 45,
        "current_step": 1125,
        "total_steps": 2500,
        "eta": 1800
    }

@app.post("/models/download")
async def download_model(model_name: str, model_type: str = "flux"):
    """Download model from Hugging Face or CivitAI"""
    if model_type == "flux":
        script = "/workspace/platform/models/download-flux.sh"
    elif model_type == "sdxl":
        script = "/workspace/platform/models/download-sdxl.sh"
    else:
        raise HTTPException(status_code=400, detail="Invalid model type")
    
    # Run download script in background
    subprocess.Popen(["bash", script])
    
    return {
        "status": "started",
        "message": f"Downloading {model_name}",
        "model_type": model_type
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)
