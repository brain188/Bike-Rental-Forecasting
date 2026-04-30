# AWS Deployment Script for Bike Rental Forecasting 
# Make sure you have AWS CLI configured with proper credentials

Write-Host " Starting AWS deployment..." -ForegroundColor Green

# Variables
$REGION = "us-east-1"
$SERVICE_NAME = "bike-rental-forecasting"
$ACCOUNT_ID = (aws sts get-caller-identity --query Account --output text)

Write-Host " Account ID: $ACCOUNT_ID" -ForegroundColor Cyan
Write-Host " Region: $REGION" -ForegroundColor Cyan

# Step 1: Create ECR repository
Write-Host " Creating ECR repository..." -ForegroundColor Yellow
try {
    aws ecr describe-repositories --repository-names $SERVICE_NAME --region $REGION 2>$null
} catch {
    aws ecr create-repository --repository-name $SERVICE_NAME --region $REGION
}

# Step 2: Login to ECR
Write-Host " Logging into ECR..." -ForegroundColor Yellow
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

# Step 3: Build and push Docker image
Write-Host " Building Docker image..." -ForegroundColor Yellow
docker build -f Dockerfile.aws -t $SERVICE_NAME .
docker tag "${SERVICE_NAME}:latest" "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/${SERVICE_NAME}:latest"

Write-Host "⬆ Pushing to ECR..." -ForegroundColor Yellow
docker push "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/${SERVICE_NAME}:latest"

# Step 4: Create App Runner service
Write-Host "🏃 Creating App Runner service..." -ForegroundColor Yellow

$sourceConfig = @{
    ImageRepository = @{
        ImageIdentifier = "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/${SERVICE_NAME}:latest"
        ImageConfiguration = @{
            Port = "8050"
            RuntimeEnvironmentVariables = @{
                PORT = "8050"
            }
        }
        ImageRepositoryType = "ECR"
    }
    AutoDeploymentsEnabled = $false
} | ConvertTo-Json -Depth 10 -Compress

$instanceConfig = @{
    Cpu = "0.25 vCPU"
    Memory = "0.5 GB"
} | ConvertTo-Json -Compress

aws apprunner create-service --service-name $SERVICE_NAME --source-configuration $sourceConfig --instance-configuration $instanceConfig --region $REGION

Write-Host " Deployment initiated! Check AWS Console for service URL." -ForegroundColor Green
Write-Host " Your app will be available at the App Runner service URL in a few minutes." -ForegroundColor Green