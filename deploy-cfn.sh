#!/bin/bash

set -e  # Exit on error
set -x  # Debug mode (optional, remove if not needed)

# Load environment variables
source /etc/environment

# Validate that CUSTOM_ENV and AWS_REGION are set
if [ -z "$CUSTOM_ENV" ]; then
  echo "❌ CUSTOM_ENV is not set. Exiting..."
  exit 1
fi

if [ -z "$AWS_REGION" ]; then
  echo "❌ AWS_REGION is not set. Exiting..."
  exit 1
fi

CFN_TEMPLATE_PATH="/home/ubuntu/s3-bucket.yml"

# Ensure the CloudFormation template exists
if [ ! -f "$CFN_TEMPLATE_PATH" ]; then
  echo "❌ CloudFormation template not found at $CFN_TEMPLATE_PATH. Exiting..."
  exit 1
fi

# Deploy the CloudFormation stack dynamically
aws cloudformation deploy \
  --template-file "$CFN_TEMPLATE_PATH" \
  --stack-name s3-bucket-stack \
  --parameter-overrides BucketName="$CUSTOM_ENV" RegionName="$AWS_REGION" \
  --region "$AWS_REGION"

echo "✅ S3 Bucket '$CUSTOM_ENV' created successfully in region '$AWS_REGION'!"

else
  echo "❌ Failed to create S3 bucket."
  exit 1
fi

