#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly LATEST_FILEPATH="$1"
readonly SLACKPOST_ID="$2"
readonly LOCK="$3"

readonly TEMP=$(mktemp --tmpdir)

check(){
  gmr owner-logs 0 1 > "$TEMP"

  # valid?
  local temp=$(cat $TEMP | head -n 1)
  if [ ${temp:0:1} -eq '{' ]; then
    return 1
  fi

  # first time
  if [ ! -e "$LATEST_FILEPATH" ]; then
    mv "$TEMP" "$LATEST_FILEPATH"	
    notify
    return 0
  fi
 
  # difference
  if ! diff -q "$LATEST_FILEPATH" "$TEMP" >/dev/null; then
    mv "$TEMP" "$LATEST_FILEPATH"	
    notify
    return 0
  fi
}

notify() {
  {
    cat "$LATEST_FILEPATH" | jq -r '.activity_date + " " + .text'
  }| slack-post -w "$SLACKPOST_ID" 

}

################################

if [ ! -e $LOCK ]; then
  touch "$LOCK"
  check 
  rm -f "$LOCK"
fi
