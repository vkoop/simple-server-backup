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

			if [[ -z $RESTORE_DAY ]]; then
				echo "missing argument"
				exit 1;
			fi

			echo "Restore day: $RESTORE_DAY"
			;;
	    f )
			echo "Output dump to file."

			if [[ -z $OPTARG ]]; then
				echo "missing argument"
				exit 1;
			fi

	        LOCAL_TARGET_FILE="$OPTARG"
	        echo "Dumping to file: $LOCAL_TARGET_FILE"
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

LOCAL_DB_HOST_FB=${LOCAL_DB_HOST:-"127.0.0.1"} 
SERVER_DB_HOST_FB=${SERVER_DB_HOST:-"127.0.0.1"}

if [[ $DIRECTION == 'ltos' ]]; then
	DUMPCOMMAND=(mysqldump -h ${LOCAL_DB_HOST_FB} -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME)
	IMPORTCOMMAND=(mysql -u$DB_USERNAME -p$DB_PASSWORD $DB_NAME --host=${SERVER_DB_HOST_FB})

	eval "${DUMPCOMMAND[@]}" | gzip | ssh $SSHOPT $SERVERHOST "gunzip | ${IMPORTCOMMAND[@]}"
elif [[ $DIRECTION == 'stol' ]]; then
	DUMPCOMMAND=(mysqldump -h ${SERVER_DB_HOST_FB} -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME)
	IMPORTCOMMAND=(mysql -u$DB_USERNAME -p$DB_PASSWORD $DB_NAME --host=${LOCAL_DB_HOST_FB})

	ssh $SSHOPT $SERVERHOST "${DUMPCOMMAND[@]} | gzip"  | gunzip | eval "${IMPORTCOMMAND[@]}"
elif [[ $DIRECTION == 'stof' ]]; then
	DUMPCOMMAND=(mysqldump -h ${SERVER_DB_HOST_FB} -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME)

    touch  "$LOCAL_TARGET_FILE"
	ssh $SSHOPT $SERVERHOST "${DUMPCOMMAND[@]} | gzip"  | gunzip > "$LOCAL_TARGET_FILE"
elif  [[ $DIRECTION == 'btos' ]]; then
	#statements
	SRC="${BASEBACKUPFOLDER}/${SERVERNAME}/DB/$RESTORE_DAY.sql"
	SQLCOMMAND="mysql --host=${SERVER_DB_HOST_FB} -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_NAME}"

	cat $SRC | gzip | ssh $SSHOPT $SERVERHOST "gunzip | $SQLCOMMAND"
fi

#echo " 
#CREATE DATABASE IF NOT EXISTS ${DB_NAME};
#GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
#FLUSH PRIVILEGES;
#" | mysql -u $LOCAL_DB_ROOT -p$LOCAL_DB_PASSWORD