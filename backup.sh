#!/bin/bash
BASEDIR=`dirname $0`


source ${BASEDIR}/backup_db.sh $1

source ${BASEDIR}/backup_server.sh $!

#shutdown -Ph now
echo "Backup finished " `date`
