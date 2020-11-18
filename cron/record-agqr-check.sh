#!/bin/bash

PATH=$PATH:/usr/local/bin
PATH=$PATH:~/bin

readonly SLACKPOST_ID="$1"

out=$(agrec -c)

if [ $? -ne 0 ]; then
  { echo "(⊃＾ω＾)⊃ AGQR RECORDING CHECK"; echo "$out"; } | slack-post -w "$SLACKPOST_ID"
fi
