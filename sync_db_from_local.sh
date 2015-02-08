#!/bin/bash

source $1 
RESTORE_DAY=$2

SSHOPT="-i ${SSHPASSFILE} -l ${SSHUSERNAME} -p 22 ${SERVERNAME}"

mysqldump -u$DB_USERNAME -p$DB_PASSWORD $DB_NAME | ssh $SSHOPT "mysql --host=127.0.0.1 -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}"
