#!/bin/bash

OPTIND=1
optspec=":h-:d:"
while getopts "$optspec" optchar; do
	case "${optchar}" in
		h )
			echo 'help...'
			exit 0
			;;
		d )
			echo 'selected'
        		DATE=$OPTARG
			;;
		- )
			case "${OPTARG}" in
				ltos)
					echo 'Sync local to server.';
					DIRECTION='ltos'
					;;
				stol)
					echo 'Sync server to local.';
					DIRECTION='stol';
					;;
			  btos)
					echo 'Restore from backup.';
					DIRECTION='btos';
					;;
				*)
					echo "Unknown option";
					exit 0
					;;
			esac;;
		*)
			echo "Missing Option";
			;;
	esac
done
shift "$((OPTIND-1))"

source $1
source "functions.sh"

if [[ $DIRECTION == 'ltos' ]]; then
	SRC=$LOCAL_DATA_TARGET
	TARGET="${SSHUSERNAME}@${SERVERHOST}:${REMOTESRC}"
elif [[ $DIRECTION == 'stol' ]]; then
	SRC="${SSHUSERNAME}@${SERVERHOST}:${REMOTESRC}"
	TARGET=$LOCAL_DATA_TARGET
else
	SRC="${BASEBACKUPFOLDER}/${SERVERNAME}/DATA/$DATE/"
	TARGET="${SSHUSERNAME}@${SERVERHOST}:${REMOTESRC}"
fi


RSNYCSHELL="ssh ${SSHOPT}"

OPT="-avh --delete --progress"

if [ $EXCLUDES ]
then
	for EX in "${EXCLUDES[@]}"; do
		OPT="$OPT --exclude $EX"
	done
fi

rsync $OPT -e "$RSNYCSHELL" $SRC $TARGET
