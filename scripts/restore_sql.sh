#!/bin/bash
set -e 

tar -xzf /var/www/backups/${PROJECT_NAME}/$BACKUP_NAME -C /tmp/

SQL_FILE=$(basename "$BACKUP_NAME" .tar.gz).sql

mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < /tmp/$SQL_FILE

rm /tmp/$SQL_FILE
echo "Done."