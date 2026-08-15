#!/bin/bash
set -e

TIMESTAMP=`date +%Y_%m_%d`;
BACKUP_NAME="files_backup_$TIMESTAMP.tar.gz"

scp -P "$SFTP_PORT" -r \
    -i "$SFTP_KEY_PATH" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o IdentitiesOnly=yes \
    "$SFTP_USER@$SFTP_HOST:$BACKUPED_DIR" /tmp/

mkdir -p /var/www/backups/${PROJECT_NAME}/

tar -czf /var/www/backups/${PROJECT_NAME}/$BACKUP_NAME -C /tmp $(basename "$BACKUPED_DIR")

rm -rf /tmp/$(basename "$BACKUPED_DIR")
echo "Done."