#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly LATEST_FILEPATH="$1"
readonly SLACKPOST_ID="$2"
readonly LOCK="$3"

readonly SCRIPT_PATH="$(readlink -e $0)"
readonly SCRIPT_DIR="$(dirname $SCRIPT_PATH)"

readonly TEMP=$(mktemp --tmpdir)

check(){
  gmr activity -l 1 0 1 > "$TEMP"

  # valid?
  local temp=$(cat $TEMP | head -n 1)
  if [ ${temp:0:1} -eq '{' ]; then
    return 1
  fi

  # first time
  if [ ! -e "$LATEST_FILEPATH" ]; then
    mv "$TEMP" "$LATEST_FILEPATH"	
    cat "$LATEST_FILEPATH" 
    return 0
  fi
 
  # difference
  if ! diff -q "$LATEST_FILEPATH" "$TEMP" >/dev/null; then
    mv "$TEMP" "$LATEST_FILEPATH"	
    cat "$LATEST_FILEPATH" 
    return 0
  fi
}

################################

if [ ! -e $LOCK ]; then
  touch "$LOCK"

  check | "${SCRIPT_DIR}/gmr-activity-notify.sh" $SLACKPOST_ID

  rm -f "$LOCK"
fi
