#!/bin/bash

source $1
source "functions.sh"

TARGET=$LOCAL_DATA_TARGET

RSNYCSHELL="-e ssh '${SSHOPT}'"

SRC="${SSHUSERNAME}@${SERVERNAME}:${REMOTESRC}"
OPT="-avh --delete --progress"

if [ $EXCLUDES ]
then
	for EX in "${EXCLUDES[@]}"; do
		OPT="$OPT --exclude $EX"
	done
fi

rsync $OPT "$RSNYCSHELL" $SRC $TARGET