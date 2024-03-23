#!/usr/bin/env bash

OPTIND=1
optspec=":h-:d:"
while getopts "$optspec" optchar; do
	case "${optchar}" in
		h )
			echo 'Usage: sync_data.sh [OPTIONS] CONFIG'
			echo 'Synchronize data between local and remote servers.'
			echo
			echo 'Options:'
			echo '  -h        Show this help message and exit.'
			echo '  -d DATE   Specify the date for restoring from backup (format: yyyy-mm-dd).'
			echo '  --ltos    Sync local to server.'
			echo '  --stol    Sync server to local.'
			echo '  --btos    Restore from backup.'
			echo
			echo 'CONFIG is the path to the configuration file.'
			exit 0
			;;
		d )
        	DATE=$OPTARG
			;;
		- )
			case "${OPTARG}" in
				ltos)
					echo 'Sync local to server.';
					SYNC_DIRECTION='ltos'
					;;
				stol)
					echo 'Sync server to local.';
					SYNC_DIRECTION='stol';
					;;
                btos)
					echo 'Restore from backup.';
					SYNC_DIRECTION='btos';
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

# if --btos check if date is set
if [[ $SYNC_DIRECTION == 'btos' ]] && [[ -z $DATE || ! $DATE =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
	echo "Date format is not correct. Correct format is: yyyy-mm-dd"
	exit 1;
fi

if [[ -z $1 ]]; then
	echo "missing configuration"
	exit 1
fi

source $1
source "functions.sh"

if [[ $SYNC_DIRECTION == 'ltos' ]]; then
	SOURCE_PATH=$LOCAL_DATA_TARGET/
	TARGET="${SSHUSERNAME}@${SERVERHOST}:${REMOTESRC}"
elif [[ $SYNC_DIRECTION == 'stol' ]]; then
	SOURCE_PATH="${SSHUSERNAME}@${SERVERHOST}:${REMOTESRC}/"
	TARGET=$LOCAL_DATA_TARGET
elif [[ $SYNC_DIRECTION == 'btos' ]]; then
	echo "Date : $DATE";
	SOURCE_PATH="${BASEBACKUPFOLDER}/${SERVERNAME}/DATA/$DATE/"
	TARGET="${SSHUSERNAME}@${SERVERHOST}:${REMOTESRC}"
else
	echo "unknown SYNC_DIRECTION!"
	exit 0;
fi


RSNYCSHELL="ssh ${SSHOPT}"

OPT="-avh --delete --progress --numeric-ids -L"

if [ $EXCLUDES ]
then
	for EX in "${EXCLUDES[@]}"; do
		OPT="$OPT --exclude $EX"
	done
fi

rsync $OPT -e "$RSNYCSHELL" $SOURCE_PATH $TARGET
