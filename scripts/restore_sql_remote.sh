#!/bin/bash
set -e 

scp -P "$SFTP_PORT" \
    -i "$SFTP_KEY_PATH" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o IdentitiesOnly=yes \
    "$SFTP_USER@$SFTP_HOST:$SFTP_DEST_DIR/$BACKUP_NAME" /tmp/$BACKUP_NAME

tar -xzf /tmp/$BACKUP_NAME -C /tmp/

SQL_FILE=$(basename "$BACKUP_NAME" .tar.gz).sql

mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < /tmp/$SQL_FILE

rm /tmp/$SQL_FILE /tmp/$BACKUP_NAME
echo "Done."