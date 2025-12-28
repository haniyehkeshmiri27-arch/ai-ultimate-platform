#!/bin/bash
# ============================================
# 🔐 AWS + GitHub Complete Setup
# ============================================

set -e

echo "🚀 Setting up AWS infrastructure and GitHub integration..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
check_prerequisites() {
    echo "📋 Checking prerequisites..."
    
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}❌ AWS CLI not found. Install: https://aws.amazon.com/cli/${NC}"
        exit 1
    fi
    
    if ! command -v terraform &> /dev/null; then
        echo -e "${YELLOW}⚠️  Terraform not found. Installing...${NC}"
        wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt update && sudo apt install terraform
    fi
    
    if ! command -v gh &> /dev/null; then
        echo -e "${YELLOW}⚠️  GitHub CLI not found. Installing...${NC}"
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update && sudo apt install gh
    fi
    
    echo -e "${GREEN}✅ All prerequisites met${NC}"
}

# Configure AWS
configure_aws() {
    echo ""
    echo "🔧 Configuring AWS..."
    
    # Check if already configured
    if aws sts get-caller-identity &> /dev/null; then
        echo -e "${GREEN}✅ AWS already configured${NC}"
        AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
        echo "   Account ID: $AWS_ACCOUNT_ID"
    else
        echo "Please configure AWS CLI:"
        aws configure
        AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    fi
    
    export AWS_ACCOUNT_ID
}

# Setup Terraform backend
setup_terraform_backend() {
    echo ""
    echo "📦 Setting up Terraform backend..."
    
    # Create S3 bucket for state
    BUCKET_NAME="ai-platform-terraform-state-${AWS_ACCOUNT_ID}"
    
    if aws s3 ls "s3://${BUCKET_NAME}" 2>&1 | grep -q 'NoSuchBucket'; then
        echo "Creating S3 bucket: ${BUCKET_NAME}"
        aws s3 mb "s3://${BUCKET_NAME}" --region us-east-1
        
        # Enable versioning
        aws s3api put-bucket-versioning \
            --bucket "${BUCKET_NAME}" \
            --versioning-configuration Status=Enabled
        
        # Enable encryption
        aws s3api put-bucket-encryption \
            --bucket "${BUCKET_NAME}" \
            --server-side-encryption-configuration '{
                "Rules": [{
                    "ApplyServerSideEncryptionByDefault": {
                        "SSEAlgorithm": "AES256"
                    }
                }]
            }'
    else
        echo -e "${GREEN}✅ S3 bucket already exists${NC}"
    fi
    
    # Create DynamoDB table for locking
    TABLE_NAME="terraform-lock"
    
    if aws dynamodb describe-table --table-name "${TABLE_NAME}" 2>&1 | grep -q 'ResourceNotFoundException'; then
        echo "Creating DynamoDB table: ${TABLE_NAME}"
        aws dynamodb create-table \
            --table-name "${TABLE_NAME}" \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --billing-mode PAY_PER_REQUEST \
            --region us-east-1
    else
        echo -e "${GREEN}✅ DynamoDB table already exists${NC}"
    fi
}

# Initialize Terraform
initialize_terraform() {
    echo ""
    echo "🏗️  Initializing Terraform..."
    
    cd terraform
    
    # Update backend configuration
    sed -i "s/bucket\s*=\s*\".*\"/bucket = \"ai-platform-terraform-state-${AWS_ACCOUNT_ID}\"/" main.tf
    
    terraform init
    terraform validate
    
    echo -e "${GREEN}✅ Terraform initialized${NC}"
    cd ..
}

# Setup GitHub secrets
setup_github_secrets() {
    echo ""
    echo "🔐 Setting up GitHub secrets..."
    
    # Check GitHub authentication
    if ! gh auth status &> /dev/null; then
        echo "Please authenticate with GitHub:"
        gh auth login
    fi
    
    # Set secrets
    echo "Setting AWS_ACCOUNT_ID..."
    gh secret set AWS_ACCOUNT_ID --body "${AWS_ACCOUNT_ID}"
    
    echo "Setting AWS_REGION..."
    gh secret set AWS_REGION --body "us-east-1"
    
    # Generate and set other secrets
    DB_PASSWORD=$(openssl rand -base64 32)
    gh secret set DB_PASSWORD --body "${DB_PASSWORD}"
    
    API_KEY=$(openssl rand -hex 32)
    gh secret set API_KEY --body "${API_KEY}"
    
    echo -e "${GREEN}✅ GitHub secrets configured${NC}"
}

# Deploy infrastructure
deploy_infrastructure() {
    echo ""
    echo "🚀 Deploying infrastructure..."
    
    read -p "Deploy infrastructure now? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd terraform
        
        terraform plan -out=tfplan
        
        echo ""
        read -p "Apply this plan? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            terraform apply tfplan
            
            # Save outputs
            terraform output -json > ../terraform-outputs.json
            
            echo -e "${GREEN}✅ Infrastructure deployed${NC}"
            
            # Display important outputs
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "📋 Important Information:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            terraform output
        fi
        
        cd ..
    fi
}

# Display summary
display_summary() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Setup Complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📋 Next Steps:"
    echo ""
    echo "1️⃣  Push code to trigger deployment:"
    echo "   git add ."
    echo "   git commit -m 'Initial deployment'"
    echo "   git push origin main"
    echo ""
    echo "2️⃣  Monitor deployment:"
    echo "   GitHub Actions: https://github.com/haniyehkeshmiri27-arch/ai-ultimate-platform/actions"
    echo ""
    echo "3️⃣  Access services:"
    echo "   AWS Console: https://console.aws.amazon.com"
    echo "   CloudWatch Logs: https://console.aws.amazon.com/cloudwatch"
    echo ""
    echo "4️⃣  Get GitHub Actions Role ARN:"
    echo "   $(terraform -chdir=terraform output -raw github_actions_role_arn 2>/dev/null || echo 'Run terraform first')"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Main execution
main() {
    echo "╔════════════════════════════════════════╗"
    echo "║  AWS + GitHub Complete Setup          ║"
    echo "║  AI Ultimate Platform                 ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    
    check_prerequisites
    configure_aws
    setup_terraform_backend
    initialize_terraform
    setup_github_secrets
    deploy_infrastructure
    display_summary
}

main
