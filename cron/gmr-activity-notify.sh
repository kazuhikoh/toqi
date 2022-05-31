#!/bin/bash

readonly SLACKPOST_ID="$1"
readonly FEED_FILEPATH="$2"

readonly FEED_TEMP=$(mktemp --tmpdir)

if [ -p /dev/stdin ]; then
  cat - >${FEED_TEMP}
else
  cat ${FEED_FILEPATH} >${FEED_TEMP}
fi

if [ ! -s ${FEED_TEMP}  ]; then
  echo "Input is empty!" >&2
  exit 0
fi

{
  cat "${FEED_TEMP}" | jq -r '.activity_date' | cut -c 1-16 # "YYYY-MM-DD mm:ss"
  cat "${FEED_TEMP}" | jq -r '.text'
} | slack-post -w "${SLACKPOST_ID}"

