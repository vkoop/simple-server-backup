#!/bin/bash
source $1
source "functions.sh"

DBFOLDER="$BASEBACKUPFOLDER/$SERVERNAME/DB"

if [ ! -d $DBFOLDER ]
then
	mkdir -p $DBFOLDER
fi

#Todays date in ISO-8601 format:
DAY0=`date "+%Y-%m-%d"`

if [ ! -f $DBFOLDER/$DAY0.sql ]
then
	touch $DBFOLDER/$DAY0.sql
fi

ssh $SSHOPT "mysqldump -u ${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}" | cat - > $DBFOLDER/$DAY0.sql

#29 days ago in ISO-8601 format
DAY29=` date -d "29 days ago" +%s`

#Delete the backup from 29 days ago, if it exists
for i in $( ls $DBFOLDER/ ); do
	FILENAME="`basename ${i}`"
	FILENAME="${FILENAME%.*}"
	FILEDATE=$(date --date $FILENAME '+%s')

	if [ $FILEDATE  -lt $DAY29 ]
	then
		rm "${DBFOLDER}/$i"
	fi
done;
