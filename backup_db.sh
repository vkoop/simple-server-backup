#!/usr/bin/env bash

BASEDIR=$(dirname $0)

source $1
source "$BASEDIR/functions.sh"

if [ -z "$DB_USERNAME" ] || [ -z "$DB_PASSWORD" ]; then
	echo "DB username or passwort not set. Will abort the backup"
	exit 1;
fi

DBFOLDER="$BASEBACKUPFOLDER/$SERVERNAME/DB"

mkdir -p $DBFOLDER

#Todays date in ISO-8601 format:
DAY0=`date "+%Y-%m-%d"`

if [ ! -f $DBFOLDER/$DAY0.sql ]
then
	touch $DBFOLDER/$DAY0.sql
fi

ssh $SSHOPT $SERVERHOST "mysqldump -u ${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}" | cat - > $DBFOLDER/$DAY0.sql

CURRENT_MONTH=$(date -d 'now' +%m)
CURRENT_YEAR=$(date -d 'now' +%Y)

#Delete the backup from 29 days ago, if it exists
for i in $( ls $DBFOLDER/ ); do
	FILENAME="$(basename ${i})"
	FILENAME="${FILENAME%.*}"
	FILEDATE=$(date --date $FILENAME '+%s')

	FILE_MONTH=$(date --date $FILENAME '+%m')
	FILE_YEAR=$(date --date $FILENAME '+%Y')

	if [ $FILE_MONTH -ne $CURRENT_MONTH ] || [ $FILE_YEAR -ne $CURRENT_YEAR ]
	then
		# only 
		if [ $(date --date $FILENAME '+%d') -ne '01' ]
		then
			rm "${DBFOLDER}/$i"
		fi
	fi
done;
