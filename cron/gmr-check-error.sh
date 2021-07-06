#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly OUT="$1"
readonly SLACKPOST_ID="$2"

# Skip?
if [ -e $LOCK ]; then
  exit 2
fi

# Check
err=$(gmr feed 0 0 1 >/dev/null 2>&1 >/dev/null)

if [ -z $err ]; then
  echo $err > "$OUT";
  cat "$OUT" | jq -r '.head.resultCode + " " + .head.message' | slack-post -w $SLACKPOST_ID
fi
