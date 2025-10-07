#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M")
FILE="/backups/pg_backup_$DATE.sql.gz"

echo "Starting backup at $DATE"

PGPASSWORD=$POSTGRES_PASSWORD pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER $POSTGRES_DB \
| gzip -9 > "$FILE"

echo "Backup saved to $FILE"

# Optional: Upload to S3 (if using AWS CLI)
aws s3 cp "$FILE" s3://machiya-storagebackup/pg_backups/

# Optional: delete backups older than 7 days
find /backups -type f -name "*.gz" -mtime +7 -exec rm {} \;

echo "Backup completed at $(date)"
