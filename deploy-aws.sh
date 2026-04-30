#!/bin/bash

# AWS Deployment Script for Bike Rental Forecasting
# Make sure you have AWS CLI configured with proper credentials

set -e

echo "🚀 Starting AWS deployment..."

# Variables
REGION="us-east-1"
SERVICE_NAME="bike-rental-forecasting"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "Account ID: $ACCOUNT_ID"
echo "Region: $REGION"

# Step 1: Create ECR repository
echo "Creating ECR repository..."
aws ecr describe-repositories --repository-names $SERVICE_NAME --region $REGION 2>/dev/null || \
aws ecr create-repository --repository-name $SERVICE_NAME --region $REGION

# Step 2: Login to ECR
echo "Logging into ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Step 3: Build and push Docker image
echo "Building Docker image..."
docker build -f Dockerfile.aws -t $SERVICE_NAME .
docker tag $SERVICE_NAME:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$SERVICE_NAME:latest

echo "Pushing to ECR..."
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$SERVICE_NAME:latest

# Step 4: Create App Runner service
echo " Creating App Runner service..."
aws apprunner create-service \
    --service-name $SERVICE_NAME \
    --source-configuration "{
        \"ImageRepository\": {
            \"ImageIdentifier\": \"$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$SERVICE_NAME:latest\",
            \"ImageConfiguration\": {
                \"Port\": \"8050\",
                \"RuntimeEnvironmentVariables\": {
                    \"PORT\": \"8050\"
                }
            },
            \"ImageRepositoryType\": \"ECR\"
        },
        \"AutoDeploymentsEnabled\": false
    }" \
    --instance-configuration "{
        \"Cpu\": \"0.25 vCPU\",
        \"Memory\": \"0.5 GB\"
    }" \
    --region $REGION

echo "Deployment initiated! Check AWS Console for service URL."
echo "Your app will be available at the App Runner service URL in a few minutes."