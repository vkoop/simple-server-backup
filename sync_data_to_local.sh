#!/bin/bash

source $1
TARGET=$LOCAL_DATA_TARGET

SSHOPT="-e ssh -i ${SSHPASSFILE} -l ${SSHUSERNAME} -p 22"

SRC="${SSHUSERNAME}@${SERVERNAME}:${REMOTESRC}"
OPT="-avh --delete --progress"

if [ $EXCLUDES ]
then
	for EX in "${EXCLUDES[@]}"; do
		OPT="$OPT --exclude $EX"
	done
fi

rsync $OPT "$SSHOPT" $SRC $TARGET
