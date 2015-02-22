#!/bin/bash
BASEDIR=$(dirname $0)

source ${BASEDIR}/backup_db.sh $1
source ${BASEDIR}/backup_server.sh $!

echo "Backup finished " $(date)
