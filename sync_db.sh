#!/usr/bin/env bash

OPTIND=1
optspec=":h-:d:f:"
while getopts "$optspec" optchar; do
	case "${optchar}" in
		h )
			echo 'help...'
			exit 0
			;;
		d)
            RESTORE_DAY=$OPTARG
			;;
	    f )
	        LOCAL_TARGET_FILE="$OPTARG"
	        echo "$LOCAL_TARGET_FILE"
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
			    stof)
			        echo 'Server to local file:';
			        DIRECTION='stof';
			        ;;
				btos)
					echo 'Restore DB from backup.';
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

DUMPCOMMAND=(mysqldump -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME)

IMPORTCOMMAND=(mysql -u$DB_USERNAME -p$DB_PASSWORD $DB_NAME --host=127.0.0.1)

if [[ $DIRECTION == 'ltos' ]]; then
	eval "${DUMPCOMMAND[@]}" | gzip | ssh $SSHOPT $SERVERHOST "gunzip | ${IMPORTCOMMAND[@]}"
elif [[ $DIRECTION == 'stol' ]]; then
	ssh $SSHOPT $SERVERHOST "${DUMPCOMMAND[@]} | gzip"  | gunzip | eval "${IMPORTCOMMAND[@]}"
elif [[ $DIRECTION == 'stof' ]]; then
    touch  "$LOCAL_TARGET_FILE"
	ssh $SSHOPT $SERVERHOST "${DUMPCOMMAND[@]} | gzip"  | gunzip > "$LOCAL_TARGET_FILE"
elif  [[ $DIRECTION == 'btos' ]]; then
	#statements
	SRC="${BASEBACKUPFOLDER}/${SERVERNAME}/DB/$RESTORE_DAY.sql"
	SQLCOMMAND="mysql --host=127.0.0.1 -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}"

	cat $SRC | gzip | ssh $SSHOPT $SERVERHOST "gunzip | $SQLCOMMAND"
fi

#echo " 
#CREATE DATABASE IF NOT EXISTS ${DB_NAME};
#GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
#FLUSH PRIVILEGES;
#" | mysql -u $LOCAL_DB_ROOT -p$LOCAL_DB_PASSWORD