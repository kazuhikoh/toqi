#!/bin/bash

readonly SLACKPOST_ID="$1"
readonly FEED_FILEPATH="$2"

readonly FEED_TEMP=$(mktemp --tmpdir 'tmp.gmr-feed-notify.XXX')

if [ -p /dev/stdin ]; then
  cat - >${FEED_TEMP}
else
  cat ${FEED_FILEPATH} >${FEED_TEMP}
fi

if [ ! -s ${FEED_TEMP}  ]; then
  echo "Input is empty!" >&2
  rm $FEED_TEMP
  exit 0
fi

{
  cat "${FEED_TEMP}" | jq -r '.body_text'
  cat "${FEED_TEMP}" | jq -r '.contents[].thumbnail'
} | slack-post -w "${SLACKPOST_ID}"

rm $FEED_TEMP
