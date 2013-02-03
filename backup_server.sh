#!/bin/bash

source $1

DATAFOLDER=$BASEBACKUPFOLDER/$SERVERNAME/DATA

if [ ! -d $DATAFOLDER ]
then
mkdir -p $DATAFOLDER
fi

#Todays date in ISO-8601 format:
DAY0=`date "+%Y-%m-%d"`

DAY1=`ls $DATAFOLDER | sort -r | head -n 1`

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
