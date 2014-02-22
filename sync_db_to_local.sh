#!/bin/bash

source $1

# Create DB
# Create user
# Grant privileges
echo " 
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
FLUSH PRIVILEGES;
" | mysql -u $LOCAL_DB_ROOT -p$LOCAL_DB_PASSWORD 

SSHOPT="-i ${SSHPASSFILE} -l ${SSHUSERNAME} -p 22 ${SERVERNAME}"
ssh $SSHOPT "mysqldump -u ${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}" | mysql -u${DB_USERNAME} -p${DB_PASSWORD} $DB_NAME
