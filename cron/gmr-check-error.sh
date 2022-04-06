#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly OUT="$1"
readonly SLACKPOST_ID="$2"

# Skip?
if [ -e $OUT ]; then
  exit 2
fi

# Check
err=$(gmr feeds 0 0 1 2>&1 >/dev/null)

if [ -n "$err" ]; then
  echo $err > "$OUT";
  cat "$OUT" | jq -r '.head.resultCode + " " + .head.message' | slack-post -w $SLACKPOST_ID
fi
