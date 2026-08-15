#!/bin/bash
set -e

TIMESTAMP=`date +%Y_%m_%d`;
BACKUP_NAME="mysql_backup_$TIMESTAMP.tar.gz"
SQL_FILE="mysql_backup_$TIMESTAMP.sql"

mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > /tmp/$BACKUP_NAME.sql

mkdir -p /var/www/backups/${PROJECT_NAME}/

tar -czf /var/www/backups/${PROJECT_NAME}/$BACKUP_NAME -C /tmp $SQL_FILE
    
rm /tmp/$SQL_FILE
echo "Done.";
