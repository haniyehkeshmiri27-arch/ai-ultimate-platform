#!/bin/bash
# ============================================
# 🔐 Setup GitHub Secrets - SECURE METHOD
# ============================================
# This script sets up all your API keys as GitHub Secrets
# Run this ONCE after rotating your exposed keys

set -e

echo "🔐 Setting up GitHub Secrets..."
echo ""
echo "⚠️  IMPORTANT: Make sure you've rotated all exposed keys first!"
echo ""
read -p "Have you rotated all your API keys? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Please rotate your keys first, then run this script again"
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install gh
fi

# Login to GitHub
if ! gh auth status &> /dev/null; then
    echo "Please login to GitHub:"
    gh auth login
fi

echo ""
echo "Enter your NEW (rotated) credentials:"
echo ""

# Hugging Face
read -p "Hugging Face Token: " HUGGINGFACE_TOKEN
gh secret set HUGGINGFACE_TOKEN --body "$HUGGINGFACE_TOKEN"

# CivitAI
read -p "CivitAI API Key: " CIVITAI_API_KEY
gh secret set CIVITAI_API_KEY --body "$CIVITAI_API_KEY"

# Google AI Studio
read -p "Google API Key (Gemini): " GOOGLE_API_KEY
gh secret set GOOGLE_API_KEY --body "$GOOGLE_API_KEY"

# OpenAI
read -p "OpenAI API Key: " OPENAI_API_KEY
gh secret set OPENAI_API_KEY --body "$OPENAI_API_KEY"

# GitHub Tokens
read -p "GitHub PAT (all permissions): " GITHUB_PAT_ALL
gh secret set GITHUB_PAT_ALL --body "$GITHUB_PAT_ALL"

# AWS
read -p "AWS Access Key ID: " AWS_ACCESS_KEY_ID
gh secret set AWS_ACCESS_KEY_ID --body "$AWS_ACCESS_KEY_ID"

read -p "AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
gh secret set AWS_SECRET_ACCESS_KEY --body "$AWS_SECRET_ACCESS_KEY"

# GCS
read -p "GCS Access Key ID: " GCS_ACCESS_KEY_ID
gh secret set GCS_ACCESS_KEY_ID --body "$GCS_ACCESS_KEY_ID"

read -p "GCS Secret Access Key: " GCS_SECRET_ACCESS_KEY
gh secret set GCS_SECRET_ACCESS_KEY --body "$GCS_SECRET_ACCESS_KEY"

# Set non-secret values
gh secret set AWS_ACCOUNT_ID --body "389745330336"
gh secret set GOOGLE_CLOUD_PROJECT --body "ultimate-vigil-471521-r4"

echo ""
echo "✅ All secrets set successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Service account keys are stored in: /home/serti/work/src/key/"
echo "2. Never commit those .json files to Git"
echo "3. Use them only on your GPU server"
echo ""
