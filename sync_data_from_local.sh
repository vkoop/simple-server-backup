#!/bin/bash

source $1
source "functions.sh"

TARGET="${SSHUSERNAME}@${SERVERHOST}:${REMOTESRC}"
SRC=$LOCAL_DATA_TARGET

RSNYCSHELL="ssh ${SSHOPT}"

OPT="-avh --delete --progress"

if [ $EXCLUDES ]
then
	for EX in "${EXCLUDES[@]}"; do
		OPT="$OPT --exclude $EX"
	done
fi

rsync $OPT -e "$RSNYCSHELL" $SRC $TARGET
