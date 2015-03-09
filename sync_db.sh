#!/bin/bash

OPTIND=1
optspec=":h-:"
while getopts "$optspec" optchar; do
	case "${optchar}" in
		h )
			echo 'help...'
			exit 0
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

IMPORTCOMMAND=(mysql -u${DB_USERNAME} -p${DB_PASSWORD} $DB_NAME --host=127.0.0.1)

if [[ $DIRECTION == 'ltos' ]]; then
	eval "${DUMPCOMMAND[@]}" | ssh $SSHOPT $SERVERHOST "${IMPORTCOMMAND[@]}"
else
	ssh $SSHOPT $SERVERHOST "${DUMPCOMMAND[@]}" | eval "${DUMPCOMMAND[@]}"
fi

#echo " 
#CREATE DATABASE IF NOT EXISTS ${DB_NAME};
#GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
#FLUSH PRIVILEGES;
#" | mysql -u $LOCAL_DB_ROOT -p$LOCAL_DB_PASSWORD 


