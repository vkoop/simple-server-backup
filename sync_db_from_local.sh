#!/bin/bash

source $1
source "functions.sh" 

mysqldump -u$DB_USERNAME -p$DB_PASSWORD $DB_NAME | ssh $SSHOPT $SERVERHOST "mysql --host=127.0.0.1 -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}"
