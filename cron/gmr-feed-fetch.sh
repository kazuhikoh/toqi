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


if [ ! -e $LOCK ]; then
  touch "$LOCK"

  gmr feeds 0 0 $PAGESIZE \
   | "${SCRIPT_DIR}/gmr-feed-merge.sh" "$DIR_ROOT" "feed-"


  rm -f "$LOCK"
fi

