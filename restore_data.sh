#!/bin/bash

source $1

#Website Backup Script
RESTORE_DAY=$2

#The source directory:
TRG="${SSHUSERNAME}@${SERVERNAME}:${REMOTETRG}"

#The target directory:
SRC="${BASEBACKUPFOLDER}/${SERVERNAME}/DATA/$RESTORE_DAY/"


SSHOPT="-i ${SSHPASSFILE} -l ${SSHUSERNAME} -p 22"

#The rsync options:
OPT="-avh --delete -e "

#Execute the backup
rsync $OPT "ssh $SSHOPT" $SRC $TRG
