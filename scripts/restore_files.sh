#!/bin/bash
set -e

rm -rf /tmp/*

tar -xzf /var/www/backups/${PROJECT_NAME}/$BACKUP_NAME -C /tmp/

EXTRACTED_DIR=$(ls -F /tmp | grep / | tr -d '/')

scp -P "$SFTP_PORT" -r \
    -i "$SFTP_KEY_PATH" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o IdentitiesOnly=yes \
    /tmp/$EXTRACTED_DIR/. "$SFTP_USER@$SFTP_HOST:$RESTORED_DIR"

rm -rf /tmp/*
echo "Done."