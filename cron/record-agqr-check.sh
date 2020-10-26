#!/bin/bash

PATH=$PATH:~/bin

readonly SLACKPOST_ID="$1"
readonly SLACKPOST_CH="$2"

out=$(agrec -c)

if [ $? -ne 0 ]; then
  { echo "(⊃＾ω＾)⊃ AGQR RECORDING CHECK"; echo "$out"; } | slack-post -w "$SLACKPOST_ID" -c "$SLACKPOST_CH"
fi
