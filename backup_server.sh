#!/bin/bash

source $1
source "functions.sh"

DATAFOLDER=$BASEBACKUPFOLDER/$SERVERNAME/DATA

if [ ! -d $DATAFOLDER ]
then
	mkdir -p $DATAFOLDER
fi

#Todays date in ISO-8601 format:
TODAY=$(date "+%Y-%m-%d")

#Search for last backup - sort reverse by date
LASTBACKUP=$(ls $DATAFOLDER | sort -r | head -n 1)

#The source directory:
SRC="${SSHUSERNAME}@${SERVERHOST}:${REMOTESRC}/"

#The target directory:
TRG="$DATAFOLDER/$TODAY"

RSNYCSHELL="ssh $SSHOPT"

#The link destination directory:
LNK="$DATAFOLDER/$LASTBACKUP"

OPT="-avh --delete --stats --progress --numeric-ids"
#The rsync options:
if [ -d $LNK ]
then
	echo 'found existing backup'
	echo "will use link-directory: $LNK"
	OPT="$OPT --link-dest=$LNK"
fi

if [ $EXCLUDES ]
then
	for EX in "${EXCLUDES[@]}"; do
		OPT="$OPT --exclude $EX"
	done
fi

#Execute the backup
rsync $OPT -e "$RSNYCSHELL" $SRC $TRG

DAY29=$(date -d "29 days ago" "+%s")

#for i in $( ls $DATAFOLDER/ ); do
	#FILENAME="$(basename ${i})"
	#FILENAME="${FILENAME%.*}"
	#FILEDATE=$(date --date $FILENAME '+%s')

	#if [ $FILEDATE  -lt $DAY29 ]
	#then
		#rm -R "$DATAFOLDER/$i"
	#fi
#done;
