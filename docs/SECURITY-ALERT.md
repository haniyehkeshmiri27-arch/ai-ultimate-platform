# 🔐 Security Alert - Important Actions Required

## ⚠️ Your Credentials Were Exposed

The following credentials were exposed in chat and **must be rotated immediately**:

### 🔴 Critical - Rotate Now:

1. **Hugging Face Token**: `hf_****...****` (starts with hf_)
2. **CivitAI API Key**: `****...****` (32 character hex)
3. **Google Gemini API Key**: `AIza****...****`
4. **OpenAI API Key**: `sk-proj-****...****`
5. **GitHub PATs**: Multiple tokens starting with `github_pat_`
6. **AWS Keys**: Access key `AKIA****...****`
7. **GCS HMAC Keys**: Access key `GOOG****...****`

---

## 🛡️ How to Rotate Each Credential

### 1. Hugging Face Token
```bash
# Go to: https://huggingface.co/settings/tokens
# 1. Delete old token (starts with hf_)
# 2. Create new token with same permissions
# 3. Save it securely
```

### 2. CivitAI API Key
```bash
# Go to: https://civitai.com/user/account
# 1. Revoke old key (32 character hex string)
# 2. Generate new API key
# 3. Save it securely
```

### 3. Google Gemini (AI Studio)
```bash
# Go to: https://makersuite.google.com/app/apikey
# 1. Delete old key (starts with AIza)
# 2. Create new API key
# 3. Save it securely
```

### 4. OpenAI API Key
```bash
# Go to: https://platform.openai.com/api-keys
# 1. Revoke exposed key (starts with sk-proj-)
# 2. Create new secret key
# 3. Save it securely
```

### 5. GitHub Personal Access Tokens
```bash
# Go to: https://github.com/settings/tokens
# 1. Delete all three exposed tokens
# 2. Create new tokens with required permissions:
#    - repo (full control)
#    - workflow
#    - write:packages
#    - delete:packages
# 3. Save them securely
```

### 6. AWS Credentials (sertila user)
```bash
# Go to: https://console.aws.amazon.com/iam/home#/users/sertila
# 1. Delete old access key (starts with AKIA)
# 2. Create new access key
# 3. Save both Access Key ID and Secret Access Key
# 4. Consider changing console password
```

### 7. Google Cloud Storage HMAC Keys
```bash
# Go to: https://console.cloud.google.com/storage/settings
# 1. Delete old key (starts with GOOG)
# 2. Create new HMAC key for service account
# 3. Save both Access ID and Secret
```

### 8. GCP Service Account Keys
```bash
# The JSON files are already saved locally in:
# /home/serti/work/src/key/
# 
# These should NOT be rotated unless compromised further
# Keep them LOCAL only, never commit to Git
```

---

## ✅ After Rotation - Setup Securely

### Step 1: Run the secure setup script
```bash
cd /home/serti/work/ai-ultimate-platform
bash infrastructure/setup-secrets.sh
```

This will:
- ✅ Store all keys as GitHub Secrets (encrypted)
- ✅ Never expose them in code or logs
- ✅ Make them available to GitHub Actions

### Step 2: On your GPU server
```bash
# Copy .env.example to .env
cp .env.example .env

# Edit .env with your NEW credentials
nano .env

# Or use this helper script:
cat > .env << 'EOF'
HUGGINGFACE_TOKEN=your_new_token
CIVITAI_API_KEY=your_new_key
GOOGLE_API_KEY=your_new_key
OPENAI_API_KEY=your_new_key
GITHUB_TOKEN=your_new_token
AWS_ACCESS_KEY_ID=your_new_key
AWS_SECRET_ACCESS_KEY=your_new_secret
GCS_ACCESS_KEY_ID=your_new_key
GCS_SECRET_ACCESS_KEY=your_new_secret
GOOGLE_APPLICATION_CREDENTIALS=/workspace/keys/service-account.json
EOF
```

### Step 3: Secure your service account keys
```bash
# On GPU server, create secure keys directory
mkdir -p /workspace/keys
chmod 700 /workspace/keys

# Copy your service account JSON files (use SCP or upload securely)
scp /home/serti/work/src/key/*.json your-gpu-server:/workspace/keys/

# Set proper permissions
chmod 600 /workspace/keys/*.json
```

---

## 🔒 Security Best Practices

### ✅ DO:
- Store credentials in GitHub Secrets
- Use `.env` files locally (never commit)
- Keep service account keys in secure directories
- Rotate credentials regularly (every 90 days)
- Use different keys for different environments

### ❌ DON'T:
- Commit credentials to Git
- Share credentials in chat/email
- Use production keys in development
- Store keys in cloud storage (S3, GCS)
- Hard-code API keys in source code

---

## 📋 Quick Rotation Checklist

- [ ] Rotate Hugging Face token
- [ ] Rotate CivitAI API key
- [ ] Rotate Google Gemini API key
- [ ] Rotate OpenAI API key
- [ ] Delete and recreate GitHub PATs
- [ ] Rotate AWS access keys
- [ ] Rotate GCS HMAC keys
- [ ] Change AWS console password
- [ ] Run `setup-secrets.sh` script
- [ ] Test new credentials work
- [ ] Update `.env` on GPU server

---

## 🆘 Need Help?

If you see unauthorized usage of your accounts:
1. **Immediately** rotate all credentials
2. Review billing and usage logs
3. Enable MFA on all accounts
4. Contact support if needed

---

**⏰ Do this NOW before someone uses your exposed credentials!**
