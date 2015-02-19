#!/bin/bash

source $1 
source "functions.sh"

RESTORE_DAY=$2

SRC="${BASEBACKUPFOLDER}/${SERVERNAME}/DB/$RESTORE_DAY.sql"

SQLCOMMAND="mysql --host=127.0.0.1 -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}"

cat $SRC | ssh $SSHOPT $SQLCOMMAND