#!/usr/bin/env bash

BASEDIR=$(dirname $0)

for f in $BASEDIR/config/*.config.sh
do
  echo "Setup ssh server: ${f}";
  source $f;

  if [ ! -f "~/.ssh/known_hosts" ]; then
    mkdir -p ~/.ssh
    touch ~/.ssh/known_hosts
  fi

  ssh-keyscan -H $SERVERHOST >> ~/.ssh/known_hosts

  echo "----------------------------------";
done
