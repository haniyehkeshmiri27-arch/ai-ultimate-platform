# 🚀 AWS + GitHub Complete Setup Guide

راهنمای کامل راه‌اندازی اتصال GitHub به AWS با دسترسی کامل

## 📋 پیش‌نیازها

### 1️⃣ AWS Account
- حساب AWS فعال
- دسترسی AdministratorAccess (یا حداقل دسترسی‌های زیر)

### 2️⃣ GitHub Account
- Repository: `ai-ultimate-platform`
- دسترسی Admin به repository

### 3️⃣ ابزارها
```bash
# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh
```

## 🎯 روش نصب سریع (یک خط!)

```bash
bash infrastructure/setup-aws-github.sh
```

این اسکریپت **همه چیز رو خودکار** انجام میده:
- ✅ نصب پیش‌نیازها
- ✅ تنظیم AWS CLI
- ✅ ساخت S3 bucket برای Terraform state
- ✅ ساخت DynamoDB برای Terraform locking
- ✅ راه‌اندازی Terraform
- ✅ تنظیم GitHub secrets
- ✅ Deploy زیرساخت AWS

## 📖 روش نصب دستی (گام به گام)

### Step 1: تنظیم AWS CLI

```bash
aws configure
```

وارد کنید:
- AWS Access Key ID
- AWS Secret Access Key  
- Default region: `us-east-1`
- Default output format: `json`

بررسی:
```bash
aws sts get-caller-identity
```

### Step 2: ساخت Terraform Backend

```bash
# دریافت Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# ساخت S3 bucket برای Terraform state
aws s3 mb "s3://ai-platform-terraform-state-${AWS_ACCOUNT_ID}" --region us-east-1

# فعال کردن versioning
aws s3api put-bucket-versioning \
    --bucket "ai-platform-terraform-state-${AWS_ACCOUNT_ID}" \
    --versioning-configuration Status=Enabled

# فعال کردن encryption
aws s3api put-bucket-encryption \
    --bucket "ai-platform-terraform-state-${AWS_ACCOUNT_ID}" \
    --server-side-encryption-configuration '{
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }]
    }'

# ساخت DynamoDB table برای locking
aws dynamodb create-table \
    --table-name terraform-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-1
```

### Step 3: راه‌اندازی Terraform

```bash
cd infrastructure/terraform

# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan -out=tfplan

# Apply
terraform apply tfplan
```

### Step 4: تنظیم GitHub Secrets

```bash
# Login به GitHub
gh auth login

# تنظیم secrets
gh secret set AWS_ACCOUNT_ID --body "YOUR_ACCOUNT_ID"
gh secret set AWS_REGION --body "us-east-1"

# Generate و set کردن passwords
gh secret set DB_PASSWORD --body "$(openssl rand -base64 32)"
gh secret set API_KEY --body "$(openssl rand -hex 32)"
```

**یا از GitHub UI:**

1. برو به: `Settings` → `Secrets and variables` → `Actions`
2. کلیک `New repository secret`
3. اضافه کن:
   - `AWS_ACCOUNT_ID`: Account ID شما
   - `AWS_REGION`: `us-east-1`
   - `DB_USER`: `admin`
   - `DB_PASSWORD`: رمز قوی
   - `API_URL`: URL سرویس
   - `FRONTEND_URL`: URL فرانت
   - `S3_BUCKET_NAME`: نام bucket
   - `CLOUDFRONT_DISTRIBUTION_ID`: ID distribution

### Step 5: دریافت GitHub Actions Role ARN

```bash
cd infrastructure/terraform
terraform output github_actions_role_arn
```

خروجی مثل این:
```
arn:aws:iam::123456789012:role/GitHubActionsRole-staging
```

این ARN رو **در GitHub workflow استفاده کن** (قبلاً اضافه شده).

## 🏗️ زیرساخت‌های ایجاد شده

### Network
- ✅ VPC با 3 Availability Zones
- ✅ Public & Private Subnets
- ✅ NAT Gateway
- ✅ Internet Gateway

### Compute
- ✅ ECS Fargate Cluster
- ✅ Application Load Balancer (HTTPS)
- ✅ Lambda Functions
- ✅ Auto Scaling

### Storage
- ✅ RDS PostgreSQL (encrypted)
- ✅ S3 Buckets (versioned, encrypted)
- ✅ ECR Repository

### CDN & DNS
- ✅ CloudFront Distribution
- ✅ ACM SSL Certificate
- ✅ Route53 (optional)

### Security
- ✅ IAM Roles with least privilege
- ✅ Security Groups
- ✅ Secrets Manager
- ✅ VPC Endpoints

### Monitoring
- ✅ CloudWatch Logs
- ✅ CloudWatch Alarms
- ✅ Container Insights

## 🎯 استفاده

### Deploy با Git Push

```bash
git add .
git commit -m "Deploy to AWS"
git push origin main
```

GitHub Actions خودکار:
1. Security scan
2. Build Docker image
3. Push به ECR
4. Deploy Terraform infrastructure
5. Deploy به ECS
6. Deploy Lambda
7. Deploy frontend به S3/CloudFront
8. Database migration
9. Integration tests

### Manual Deploy

```bash
# Specific environment
gh workflow run aws-deploy.yml -f environment=production

# از UI
# GitHub → Actions → AWS Complete Deployment → Run workflow
```

### مشاهده Logs

```bash
# ECS logs
aws logs tail /ecs/ai-platform-staging --follow

# Lambda logs
aws logs tail /aws/lambda/ai-platform-processor-staging --follow
```

## 📊 Monitoring

### CloudWatch Dashboards

```bash
# ساخت dashboard
aws cloudwatch put-dashboard \
    --dashboard-name ai-platform-staging \
    --dashboard-body file://infrastructure/cloudwatch-dashboard.json
```

### Alarms

```bash
# High CPU alarm
aws cloudwatch put-metric-alarm \
    --alarm-name ai-platform-high-cpu \
    --alarm-description "Alert when CPU exceeds 80%" \
    --metric-name CPUUtilization \
    --namespace AWS/ECS \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold
```

## 💰 تخمین هزینه (ماهانه)

### Staging Environment (~$50-100/month)
- ECS Fargate (t4g.micro equivalent): $15-30
- RDS db.t4g.micro: $15-20
- NAT Gateway: $30-40
- S3 + CloudFront: $5-10
- Lambda: $0-5
- Data Transfer: $5-10

### Production Environment (~$200-500/month)
- ECS Fargate (multi-AZ): $100-200
- RDS db.r6g.large: $150-200
- NAT Gateway (multi-AZ): $60-80
- S3 + CloudFront: $20-40
- Lambda: $10-20
- Data Transfer: $20-50

## 🔐 امنیت

### Best Practices

1. **IAM Roles**: از OIDC استفاده کن، نه AWS Keys
2. **Secrets**: همیشه از Secrets Manager
3. **Encryption**: همه data at rest و in transit
4. **Network**: Private subnets برای compute
5. **Logging**: همه چیز رو log کن
6. **Scanning**: Container security scanning

### Security Checklist

- [ ] AWS Keys نباید در Git باشند
- [ ] Secrets در Secrets Manager
- [ ] SSL/TLS برای همه connections
- [ ] Security Groups به حداقل محدود
- [ ] CloudTrail فعال
- [ ] GuardDuty فعال
- [ ] Backup strategy تعریف شده

## 🐛 عیب‌یابی

### Terraform Errors

```bash
# State lock
terraform force-unlock LOCK_ID

# State drift
terraform refresh
terraform plan

# Destroy specific resource
terraform destroy -target=aws_ecs_service.main
```

### ECS Tasks Not Starting

```bash
# Check logs
aws ecs describe-tasks --cluster ai-platform-cluster-staging --tasks TASK_ARN

# Check events
aws ecs describe-services --cluster ai-platform-cluster-staging --services ai-platform-service-staging
```

### GitHub Actions Failing

```bash
# Check role assumption
aws sts assume-role-with-web-identity \
    --role-arn arn:aws:iam::ACCOUNT:role/GitHubActionsRole \
    --role-session-name test \
    --web-identity-token TOKEN
```

## 📚 منابع

- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions AWS](https://github.com/aws-actions)
- [ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/)

## 🆘 پشتیبانی

مشکل داری؟
1. بررسی CloudWatch Logs
2. بررسی GitHub Actions logs
3. بررسی Terraform state
4. بررسی AWS Health Dashboard

---

**🎉 حالا سیستم کاملا خودکار و production-ready است!**
