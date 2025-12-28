#!/bin/bash
# ============================================
# 🚀 Start All Services
# ============================================

echo "🚀 Starting AI Ultimate Platform..."
echo ""

# Check if in workspace
if [ ! -d "/workspace" ]; then
    echo "⚠️  Not in /workspace, using current directory"
    WORKSPACE=$(pwd)
else
    WORKSPACE="/workspace"
fi

# Start ComfyUI
echo "🎨 Starting ComfyUI..."
cd $WORKSPACE/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 > /tmp/comfyui.log 2>&1 &
echo "   PID: $!"
echo "   URL: http://localhost:8188"

# Wait a bit
sleep 2

# Start Kohya SS
echo "🎓 Starting Kohya SS..."
cd $WORKSPACE/kohya_ss
nohup bash gui.sh --listen 0.0.0.0 --server_port 7860 > /tmp/kohya.log 2>&1 &
echo "   PID: $!"
echo "   URL: http://localhost:7860"

# Wait a bit
sleep 2

# Start API Server
echo "🌐 Starting API Server..."
cd $WORKSPACE/platform/web/backend
nohup python3 -m uvicorn main:app --host 0.0.0.0 --port 5000 > /tmp/api.log 2>&1 &
echo "   PID: $!"
echo "   URL: http://localhost:5000"

# Start TensorBoard (optional)
echo "📊 Starting TensorBoard..."
nohup tensorboard --logdir=$WORKSPACE/training/logs --host 0.0.0.0 --port 6006 > /tmp/tensorboard.log 2>&1 &
echo "   PID: $!"
echo "   URL: http://localhost:6006"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All services started!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Access URLs:"
echo "   ComfyUI:     http://localhost:8188"
echo "   Kohya SS:    http://localhost:7860"
echo "   API:         http://localhost:5000/docs"
echo "   TensorBoard: http://localhost:6006"
echo ""
echo "📝 Logs:"
echo "   tail -f /tmp/comfyui.log"
echo "   tail -f /tmp/kohya.log"
echo "   tail -f /tmp/api.log"
echo ""
echo "🛑 Stop all: pkill -f 'python.*ComfyUI|kohya|uvicorn|tensorboard'"
