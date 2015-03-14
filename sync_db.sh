#!/bin/bash

OPTIND=1
optspec=":h-:d:"
while getopts "$optspec" optchar; do
	case "${optchar}" in
		h )
			echo 'help...'
			exit 0
			;;
		d)
			echo 'selected'
        		RESTORE_DAY=$OPTARG
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
					echo 'Restore DB from backup.';
					DIRECTION='btol';
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
elif [[ $DIRECTION == 'btos' ]]; then
	SRC="${BASEBACKUPFOLDER}/${SERVERNAME}/DB/$RESTORE_DAY.sql"
	SQLCOMMAND="mysql --host=127.0.0.1 -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}"

	cat $SRC | gzip | ssh $SSHOPT $SERVERHOST "gunzip | $SQLCOMMAND"
else
	#statements
	ssh $SSHOPT $SERVERHOST "${DUMPCOMMAND[@]} | gzip"  | gunzip | eval "${IMPORTCOMMAND[@]}"
fi

#echo " 
#CREATE DATABASE IF NOT EXISTS ${DB_NAME};
#GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
#FLUSH PRIVILEGES;
#" | mysql -u $LOCAL_DB_ROOT -p$LOCAL_DB_PASSWORD 


