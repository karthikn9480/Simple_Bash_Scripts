#!/bin/bash

# Define variables
LOG_FILE="/var/log/nginx/error.log"
S3_BUCKET="my-app-bucket-28"
AWS_REGION="us-east-1"
TIMESTAMP=$(date +%d-%m-%Y_%H-%M-%S)
ZIP_FILE="$(hostname)-nginx-error-log-${TIMESTAMP}.zip"

# Switch to Nginx log folder
cd "$(dirname "$LOG_FILE")" || exit

# Zip only the error log
sudo zip -r "$ZIP_FILE" "$(basename "$LOG_FILE")"

echo "Compressing process completed!"

# Move the zip file to S3 bucket
echo "Starting log migration process to S3 bucket..."
aws s3 mv "$ZIP_FILE" "s3://$S3_BUCKET/" --region "$AWS_REGION"

echo "Logs uploaded successfully to:"
echo "https://s3-${AWS_REGION}.amazonaws.com/${S3_BUCKET}/${ZIP_FILE}"

echo "Log migration process completed!"
