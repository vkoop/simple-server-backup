#!/bin/bash

BASEDIR=$(dirname $0)

for f in $BASEDIR/config/*.config.sh
do
  echo "Starting backup with config: ${f}";
  source $BASEDIR/backup.sh $f;
  echo "----------------------------------";
done
