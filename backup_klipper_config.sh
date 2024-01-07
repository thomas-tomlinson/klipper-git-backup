#!/bin/bash

BACKUP_DIR=~/git_backup

# ensure backup directory exists

if [ ! -d ~/git_backup ];
then
  echo "ERROR: git backup directory doesn't exist"
  exit 2
fi

# copy files to backup directory
pushd ~/printer_data/config
find . -regextype posix-egrep -regex '.*/*(cfg|conf)' -type f -print | grep -v 'printer-[0-9]' | while read NAME
do
  cp --parents -r $NAME ${BACKUP_DIR}/
done

# do git stuff and push commit

pushd $BACKUP_DIR
git add .
git commit -am "backup $(date +%Y/%m/%d-%H:%M:%S)"
git push
