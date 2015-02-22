#!/bin/bash

source $1
source "functions.sh"

# Create DB
# Create user
# Grant privileges
echo " 
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
FLUSH PRIVILEGES;
" | mysql -u $LOCAL_DB_ROOT -p$LOCAL_DB_PASSWORD 

ssh $SSHOPT $SERVERNAME "mysqldump -u ${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}" | mysql -u${DB_USERNAME} -p${DB_PASSWORD} $DB_NAME
