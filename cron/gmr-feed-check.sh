#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly DEBUG=false

readonly DIR_ROOT="$1"
readonly PAGESIZE=$2
readonly LOCK="$3"

readonly SCRIPT_PATH="$(readlink -e $0)"
readonly SCRIPT_DIR="$(dirname $SCRIPT_PATH)"

readonly TEMP_DIR=$(mktemp --tmpdir -d 'gmr-feed-fetch.XXX')
readonly TEMP_LATEST="$TEMP_DIR/latest"
readonly TEMP_FEED="$TEMP_DIR/feed-"


fetch(){
  local pagesize=$1

  gmr feeds 0 0 $pagesize 
}

merge(){
  local dir=$1

  "${SCRIPT_DIR}/gmr-feed-merge.sh" "$dir" "feed-"
}

################################

if [ ! -e $LOCK ]; then
  touch "$LOCK"
  fetch $PAGESIZE | merge "$DIR_ROOT"
  rm -f "$LOCK"
fi

