#!/bin/bash

source $1

#Create user TODO: use mysql password , only if set
#TODO: perhapse check before creating user
echo "CREATE USER '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}'; 
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
" | mysql -u $LOCAL_DB_ROOT -p$LOCAL_DB_PASSWORD 

SSHOPT="-i ${SSHPASSFILE} -l ${SSHUSERNAME} -p 22 ${SERVERNAME}"
ssh $SSHOPT "mysqldump -u ${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}" | mysql -u${DB_USERNAME} -p${DB_PASSWORD} $DB_NAME
