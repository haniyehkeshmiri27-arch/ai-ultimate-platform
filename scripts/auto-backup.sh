#!/bin/bash
# ============================================
# 🔄 Automated Backup System
# ============================================
set -e

BACKUP_DIR="${BACKUP_DIR:-/workspace/backups}"
GCS_BUCKET="${GCS_BUCKET:-gs://ai-models-backup}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "💾 Starting automated backup..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR/$TIMESTAMP"

# Backup trained models
echo "📦 Backing up trained models..."
if [ -d "/workspace/training/output" ]; then
    cp -r /workspace/training/output "$BACKUP_DIR/$TIMESTAMP/"
    echo "✅ Trained models backed up"
fi

# Backup custom LoRAs
echo "📦 Backing up custom LoRAs..."
if [ -d "/workspace/ComfyUI/models/loras" ]; then
    mkdir -p "$BACKUP_DIR/$TIMESTAMP/loras"
    find /workspace/ComfyUI/models/loras -name "*.safetensors" -mtime -7 \
        -exec cp {} "$BACKUP_DIR/$TIMESTAMP/loras/" \;
    echo "✅ LoRAs backed up"
fi

# Backup workflows
echo "📦 Backing up workflows..."
if [ -d "/workspace/workflows" ]; then
    cp -r /workspace/workflows "$BACKUP_DIR/$TIMESTAMP/"
    echo "✅ Workflows backed up"
fi

# Backup configs
echo "📦 Backing up configurations..."
if [ -d "/workspace/platform/config" ]; then
    cp -r /workspace/platform/config "$BACKUP_DIR/$TIMESTAMP/"
    echo "✅ Configs backed up"
fi

# Create metadata
cat > "$BACKUP_DIR/$TIMESTAMP/metadata.json" << EOF
{
  "timestamp": "$TIMESTAMP",
  "date": "$(date -Iseconds)",
  "hostname": "$(hostname)",
  "gpu": "$(nvidia-smi --query-gpu=name --format=csv,noheader | head -1)",
  "backup_size": "$(du -sh $BACKUP_DIR/$TIMESTAMP | cut -f1)"
}
EOF

echo ""
echo "✅ Local backup complete: $BACKUP_DIR/$TIMESTAMP"
echo ""

# Upload to Google Cloud Storage
if command -v gsutil &> /dev/null; then
    echo "☁️  Uploading to Google Cloud Storage..."
    gsutil -m rsync -r "$BACKUP_DIR/$TIMESTAMP" "$GCS_BUCKET/backups/$TIMESTAMP"
    echo "✅ Uploaded to: $GCS_BUCKET/backups/$TIMESTAMP"
else
    echo "⚠️  gsutil not found, skipping cloud backup"
fi

# Cleanup old backups (keep last 7 days locally)
echo ""
echo "🧹 Cleaning up old backups..."
find "$BACKUP_DIR" -type d -mtime +7 -exec rm -rf {} + 2>/dev/null || true
echo "✅ Cleanup complete"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Backup completed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
