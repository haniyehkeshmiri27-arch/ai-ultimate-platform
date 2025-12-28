# 🎓 Training Guide

Complete guide to training custom models.

---

## LoRA Training

### Preparation

1. **Collect Images**
   - 20-50 high-quality images
   - Various angles and lighting
   - Consistent subject
   - Resolution: 1024x1024 or higher

2. **Organize Dataset**
   ```bash
   /workspace/training/input/10_subject/
   ├── photo_001.jpg
   ├── photo_001.txt  # "subject, description"
   ├── photo_002.jpg
   ├── photo_002.txt
   └── ...
   ```

3. **Caption Files**
   Each `.txt` file should contain:
   ```
   subject, woman with long hair, wearing casual clothes, natural lighting
   ```

### Training Steps

1. **Start Kohya SS**
   ```bash
   cd /workspace/kohya_ss
   bash gui.sh --listen 0.0.0.0 --server_port 7860
   ```

2. **Open GUI**
   http://localhost:7860

3. **Load Configuration**
   - Click "Configuration" tab
   - Load: `/workspace/platform/training/lora/flux-lora-config.toml`

4. **Review Settings**
   - Model: Flux.1 Dev or SDXL
   - Steps: 2500
   - Learning Rate: 0.0001
   - Batch Size: 1

5. **Start Training**
   - Click "Start Training"
   - Monitor via TensorBoard: http://localhost:6006

### Configuration Options

| Parameter | Recommended | Purpose |
|-----------|-------------|---------|
| `network_dim` | 128 | LoRA rank (higher = more detail) |
| `learning_rate` | 0.0001 | Training speed |
| `max_train_steps` | 2500 | Total iterations |
| `save_every_n_steps` | 250 | Checkpoint frequency |
| `batch_size` | 1 | Images per step |
| `gradient_accumulation` | 4 | Effective batch size |

### Monitoring

```bash
# Start TensorBoard
tensorboard --logdir=/workspace/training/logs --port=6006

# Watch progress
tail -f /workspace/training/logs/*.log
```

### Output

Trained LoRA will be saved to:
```
/workspace/training/output/flux_lora_XXXXX.safetensors
```

---

## Full Fine-tuning

For maximum quality and accuracy.

### When to Use

- Need 95%+ accuracy
- Training on 100+ images
- Professional production use
- Budget allows (4-8 hours on A6000)

### Requirements

- GPU: 48GB VRAM (A6000, A100)
- Time: 4-8 hours
- Images: 50-100+
- Storage: 10-20GB

### Configuration

Use `training/finetune/full-finetune-config.toml`

Key differences from LoRA:
```toml
# No LoRA - train full model
network_module = ""

# Lower learning rate
learning_rate = 0.000001

# More epochs
max_train_epochs = 50

# Prior preservation
with_prior_preservation = true
prior_loss_weight = 1.0
```

---

## Dataset Best Practices

### Image Quality

✅ **Good:**
- Clear, sharp focus
- Good lighting
- Various angles
- Natural expressions
- 1024x1024 or higher

❌ **Bad:**
- Blurry or out of focus
- Over/under exposed
- Same angle/pose
- Low resolution
- Heavily filtered

### Captions

✅ **Good:**
```
subject, woman with curly brown hair, blue eyes, wearing red sweater, indoor setting, natural lighting, smiling
```

❌ **Bad:**
```
woman
```

### Dataset Size

| Images | Quality | Training Time |
|--------|---------|---------------|
| 10-20 | Basic | 30-45 min |
| 20-50 | Good | 45-90 min |
| 50-100 | Great | 1.5-3 hours |
| 100+ | Professional | 3-8 hours |

---

## Troubleshooting

### Overfitting

**Symptoms:**
- Generated images look exactly like training set
- No variation

**Solutions:**
- Reduce steps to 1500-2000
- Increase dropout to 0.2
- Add more diverse images

### Underfitting

**Symptoms:**
- Subject not recognized
- Low quality

**Solutions:**
- Increase steps to 3000+
- Increase network_dim to 256
- Check captions

### Out of Memory

**Solutions:**
```toml
train_batch_size = 1
gradient_accumulation_steps = 2
gradient_checkpointing = true
```

---

## Advanced Topics

### Multi-Subject Training

Train multiple subjects in one LoRA:
```
/workspace/training/input/
├── 10_person1/
├── 10_person2/
└── 10_style/
```

### Style Training

Focus on artistic style rather than subject:
- Use varied subjects
- Consistent style
- Caption emphasizes style

### DreamBooth vs LoRA

| Feature | LoRA | DreamBooth |
|---------|------|------------|
| Speed | Fast (1-2hr) | Slow (4-8hr) |
| Quality | Good (85%) | Excellent (95%) |
| Size | Small (50-200MB) | Large (4-7GB) |
| Flexibility | High | Medium |

---

## Next Steps

- [Cloud Deployment](CLOUD-DEPLOYMENT.md)
- [API Usage](API-REFERENCE.md)
- [Troubleshooting](TROUBLESHOOTING.md)
