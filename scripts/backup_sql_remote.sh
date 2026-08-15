#!/bin/bash
set -e

TIMESTAMP=`date +%Y_%m_%d`;
BACKUP_NAME="mysql_backup_$TIMESTAMP.tar.gz"
SQL_FILE="mysql_backup_$TIMESTAMP.sql"

mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > /tmp/$SQL_FILE

mkdir -p /var/www/backups/${PROJECT_NAME}/

tar -czf /tmp/$BACKUP_NAME -C /tmp $SQL_FILE

scp -P "$SFTP_PORT" \
    -i "$SFTP_KEY_PATH" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o IdentitiesOnly=yes \
    /tmp/$BACKUP_NAME "$SFTP_USER@$SFTP_HOST:$SFTP_DEST_DIR/"
    
rm /tmp/$SQL_FILE /tmp/$BACKUP_NAME
echo "Done."