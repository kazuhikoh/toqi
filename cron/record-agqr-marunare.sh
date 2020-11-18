#!/bin/bash

PATH=$PATH:~/bin

readonly LENGTH=1800
readonly OUT="${1%/}/marunare.$(date "+%Y%m%d").live.mp4"
readonly SLACKPOST_ID="$2"

agrec $LENGTH "$OUT" | slack-post -w "$SLACKPOST_ID"
