#!/bin/bash

# Set the current date for the backup file names
CURRENT_DATE=$(date +"%Y-%m-%d")

# Define paths to be backed up
NGINX_CONFIG_DIR="/etc/nginx"
NGINX_LOG_DIR="/var/log/nginx"
NGINX_HTML_DIR="/var/www"
SSL_CERTS_DIR="/etc/ssl"
#DATABASE_NAME="mydatabase"  # Replace with your actual database name
#DB_USER="admin"  # Replace with your actual database user
#DB_PASSWORD="password"  # Replace with your actual database password
S3_BUCKET="s3://my-app-bucket28"
BACKUP_DIR="/tmp/nginx-backup-${CURRENT_DATE}"

# Create the backup directory on local instance
mkdir -p ${BACKUP_DIR}

# Step 1: Backup Nginx configuration and related files
echo "Backing up Nginx configuration and HTML files..."
tar -czf ${BACKUP_DIR}/nginx_config_backup_${CURRENT_DATE}.tar.gz ${NGINX_CONFIG_DIR} ${NGINX_HTML_DIR} ${NGINX_LOG_DIR} ${SSL_CERTS_DIR}

# Step 2: Backup MySQL Database 
echo "Backing up MySQL database..."
mysqldump -u "$Database_Username" -p"$Database_Password" "$Database_Name" > ${BACKUP_DIR}/mysql_backup_${CURRENT_DATE}.sql

# Step 3: Upload the backup to S3
echo "Uploading backup to S3..."
aws s3 cp ${BACKUP_DIR}/nginx_config_backup_${CURRENT_DATE}.tar.gz ${S3_BUCKET}/nginx-backups/${CURRENT_DATE}/
aws s3 cp ${BACKUP_DIR}/mysql_backup_${CURRENT_DATE}.sql ${S3_BUCKET}/mysql-backups/${CURRENT_DATE}/

# Step 4: Clean up the backup directory
echo "Cleaning up local backup directory..."
rm -rf ${BACKUP_DIR}

# Completion message
echo "Backup completed successfully and uploaded to S3!"
