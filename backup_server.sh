#!/usr/bin/env bash

BASEDIR=$(dirname $0)

source $1
source "$BASEDIR/functions.sh"

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
if [ -d "$LNK" ]
then
	echo 'found existing backup'
	echo "will use link-directory: $LNK"
	OPT="$OPT --link-dest=$LNK"
fi

if [ "$EXCLUDES" ]
then
	for EX in "${EXCLUDES[@]}"; do
		OPT="$OPT --exclude $EX"
	done
fi

#Execute the backup
rsync $OPT -e "$RSNYCSHELL" "$SRC" "$TRG"
