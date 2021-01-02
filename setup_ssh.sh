#!/usr/bin/env bash

echo "Starting SSH setup"

BASEDIR=$(dirname $0)

for configFile in $BASEDIR/config/*.config.sh
do
  echo "Setup ssh server: ${configFile}";
  source "$configFile";

  if [ ! -f "$HOME/.ssh/known_hosts" ]; then
    mkdir -p "$HOME/.ssh"
    touch "$HOME/.ssh/known_hosts"
  fi

  ssh-keyscan -H "$SERVERHOST" >> "$HOME/.ssh/known_hosts"

  echo "----------------------------------";
done

echo "Finished SSH setup"