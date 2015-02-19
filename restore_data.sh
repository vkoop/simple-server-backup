#!/bin/bash

source $1
source "functions.sh"

#Website Backup Script
RESTORE_DAY=$2

#The source directory:
TRG="${SSHUSERNAME}@${SERVERNAME}:${REMOTESRC}"

#The target directory:
SRC="${BASEBACKUPFOLDER}/${SERVERNAME}/DATA/$RESTORE_DAY/"

#The rsync options:
OPT="-avh --delete -e "

#Execute the backup
rsync $OPT "ssh $SSHOPT" $SRC $TRG