#!/bin/bash
# ============================================
# 🛑 Stop All Services
# ============================================

echo "🛑 Stopping all services..."
echo ""

# Stop ComfyUI
echo "Stopping ComfyUI..."
pkill -f "python.*ComfyUI"

# Stop Kohya
echo "Stopping Kohya SS..."
pkill -f "kohya.*gui"

# Stop API
echo "Stopping API Server..."
pkill -f "uvicorn"

# Stop TensorBoard
echo "Stopping TensorBoard..."
pkill -f "tensorboard"

echo ""
echo "✅ All services stopped"
