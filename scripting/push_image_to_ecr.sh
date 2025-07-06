#!/bin/bash

# --- Configuration ---
# In a real project, you'd load these from a file, but we define them here for simplicity.
AWS_ACCOUNT_ID="123456789012"
AWS_REGION="us-east-1"
ECR_REPOSITORY_NAME="my-awesome-app"

# --- Script Logic ---

# Stop the script if any command fails. This is our safety net.
set -e

# Check if we got the two required arguments: the local image and the new tag.
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <local-image-name> <new-version-tag>"
    echo "Example: $0 my-app:latest v1.2.0"
    exit 1
fi

LOCAL_IMAGE=$1
NEW_TAG=$2

# Construct the full ECR image URI.
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
FULL_IMAGE_NAME="${ECR_URI}/${ECR_REPOSITORY_NAME}:${NEW_TAG}"

echo "[INFO] Starting ECR push for image: $FULL_IMAGE_NAME"

# Step 1: Log Docker into the Amazon ECR registry.
# This command securely retrieves a temporary access token from AWS and pipes it
# to the 'docker login' command. The password is never shown on screen.
echo "[STEP 1/3] Authenticating Docker with AWS ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$ECR_URI"

# Step 2: Tag the local image with the ECR repository URI.
# Docker needs this specific tag format to know where to push the image.
echo "[STEP 2/3] Tagging local image..."
docker tag "$LOCAL_IMAGE" "$FULL_IMAGE_NAME"

# Step 3: Push the newly tagged image to ECR.
# This is the step that uploads your image to the cloud.
echo "[STEP 3/3] Pushing image to ECR..."
docker push "$FULL_IMAGE_NAME"

echo ""
echo "--------------------------------------------------"
echo "✅ Successfully pushed image to ECR:"
echo "$FULL_IMAGE_NAME"
echo "--------------------------------------------------"
