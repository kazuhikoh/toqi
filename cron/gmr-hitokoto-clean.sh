#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly HITOKOTO_DIR="$1"
readonly GDRIVE_UPLOAD_DIR="$2"
readonly SLACKPOST_ID="$3"

readonly TEMP_BACKUP_LIST=$(mktemp --tmpdir)
readonly TEMP_LOCALONLY_LIST=$(mktemp --tmpdir)

{
  cd "$HITOKOTO_DIR"

  for dir in $(ls -1)
  do
    # Skip this month
    y=$(echo "$dir" | grep -oP '[0-9]+(?=年)')
    m=$(echo "$dir" | grep -oP '[0-9]+(?=月)')
    now=$(date '+%Y %-m') 
    if [ "$y $m" = "$now" ]; then
      echo "$dir KEEP ($y/$m)"
      continue
    fi

    skicka ls -ll "${GDRIVE_UPLOAD_DIR%/}/$dir" > $TEMP_BACKUP_LIST
    echo -n "" > $TEMP_LOCALONLY_LIST

    # Find backup
    for file in $(ls -1 $dir)
    do
      hash=$(md5sum "${dir%/}/$file" | grep -oP '^[^ ]+')
      grep $hash $TEMP_BACKUP_LIST >/dev/null 2>/dev/null || {
        echo "$hash $file" >> $TEMP_LOCALONLY_LIST
      }
    done

    # Delete directory has been backed up
    if [ -s $TEMP_LOCALONLY_LIST ]; then
      echo "$dir KEEP"
      cat $TEMP_LOCALONLY_LIST
    else
      echo "$dir CLEAN"
      rm -rf "$dir"
    fi
  done
} | slack-post -w $SLACKPOST_ID

