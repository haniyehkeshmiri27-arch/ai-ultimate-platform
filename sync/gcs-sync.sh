#!/bin/bash
# ============================================
# ☁️ Google Cloud Storage Sync
# ============================================
set -e

BUCKET="${GCS_BUCKET:-gs://ai-models-storage}"
LOCAL_PATH="${LOCAL_PATH:-/workspace}"

echo "☁️  Google Cloud Storage Sync"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ Not authenticated. Run:"
    echo "   gcloud auth login"
    exit 1
fi

# Functions
download_from_gcs() {
    echo "📥 Downloading from GCS: $BUCKET → $LOCAL_PATH"
    
    gsutil -m rsync -r -d \
        "$BUCKET/models" "$LOCAL_PATH/ComfyUI/models"
    
    gsutil -m rsync -r -d \
        "$BUCKET/loras" "$LOCAL_PATH/ComfyUI/models/loras"
    
    gsutil -m rsync -r -d \
        "$BUCKET/workflows" "$LOCAL_PATH/workflows"
    
    echo "✅ Download complete"
}

upload_to_gcs() {
    echo "📤 Uploading to GCS: $LOCAL_PATH → $BUCKET"
    
    # Upload new LoRAs
    gsutil -m rsync -r -u \
        "$LOCAL_PATH/training/output" "$BUCKET/loras/custom"
    
    # Upload custom models
    gsutil -m rsync -r -u \
        "$LOCAL_PATH/ComfyUI/models/loras" "$BUCKET/loras"
    
    # Upload workflows
    gsutil -m rsync -r -u \
        "$LOCAL_PATH/workflows" "$BUCKET/workflows"
    
    echo "✅ Upload complete"
}

auto_sync() {
    echo "🔄 Starting auto-sync (every 30 minutes)..."
    while true; do
        sleep 1800
        echo "⏰ $(date): Running scheduled sync..."
        upload_to_gcs
    done
}

backup_all() {
    echo "💾 Creating full backup..."
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    
    gsutil -m rsync -r \
        "$LOCAL_PATH/ComfyUI/models" "$BUCKET/backups/$TIMESTAMP/models"
    
    gsutil -m rsync -r \
        "$LOCAL_PATH/training" "$BUCKET/backups/$TIMESTAMP/training"
    
    echo "✅ Backup saved to: $BUCKET/backups/$TIMESTAMP"
}

# Main
case "${1:-}" in
    download|pull)
        download_from_gcs
        ;;
    upload|push)
        upload_to_gcs
        ;;
    sync)
        upload_to_gcs
        download_from_gcs
        ;;
    auto)
        auto_sync
        ;;
    backup)
        backup_all
        ;;
    *)
        echo "Usage: $0 {download|upload|sync|auto|backup}"
        echo ""
        echo "Commands:"
        echo "  download  - Download from GCS"
        echo "  upload    - Upload to GCS"
        echo "  sync      - Bi-directional sync"
        echo "  auto      - Auto-sync every 30 min"
        echo "  backup    - Create timestamped backup"
        exit 1
        ;;
esac
