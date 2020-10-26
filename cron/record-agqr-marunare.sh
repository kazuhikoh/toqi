#!/bin/bash

PATH=$PATH:~/bin

readonly LENGTH=1800
readonly OUT="${1%/}/marunare.$(date "+%Y%m%d").live.mp4"
readonly SLACKPOST_ID="$2"
readonly SLACKPOST_CH="$3"

agrec $LENGTH "$OUT" | slack-post -w "$SLACKPOST_ID" -c "$SLACKPOST_CH"
