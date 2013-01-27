#!/bin/bash

source $1

if [ ! -d $BASEBACKUPFOLDER/$SERVERNAME ]
then
mkdir $BASEBACKUPFOLDER/$SERVERNAME
fi

DATAFOLDER=$BASEBACKUPFOLDER/$SERVERNAME/DATA

if [ ! -d $DATAFOLDER ]
then
mkdir $DATAFOLDER
fi

#Todays date in ISO-8601 format:
DAY0=`date "+%Y-%m-%d"`

#Yesterdays date in ISO-8601 format:
DAY1=`date "+%Y-%m-%d" -d "1 day ago"`

#The source directory:
SRC="${SSHUSERNAME}@${SERVERNAME}:${REMOTESRC}"

#The target directory:
TRG="$DATAFOLDER/$DAY0"

SSHOPT="ssh -i ${SSHPASSFILE} -l ${SSHUSERNAME} -p 22"

#The link destination directory:
LNK="$DATAFOLDER/$DAY1"

#The rsync options:
if [ -d $LNK ]
then
OPT="-avh --delete --link-dest=$LNK -e "
else
OPT='-avh --delete --stats -e '
fi

#Execute the backup
rsync $OPT "$SSHOPT" $SRC $TRG


DAY29=`date -d "29 days ago" "+%s"`


for i in $( ls $DATAFOLDER/ ); do
	FILENAME="`basename ${i}`"
	FILENAME="${FILENAME%.*}"
	FILEDATE=$(date --date $FILENAME '+%s')

	if [ $FILEDATE  -lt $DAY29 ]
	then
		rm -R $i
	fi
done;
