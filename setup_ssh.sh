#!/bin/bash

BASEDIR=$(dirname $0)

for f in $BASEDIR/config/*.config.sh
do
  echo "Setup ssh server: ${f}";
  source $f;

  ssh-keyscan -H $SERVERHOST >> ~/.ssh/known_hosts

  echo "----------------------------------";
done
