#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly DIR_FEEDS="$1"
readonly SLACKPOST_ID="$2"
readonly LOCK="$3"

readonly SCRIPT_PATH="$(readlink -e $0)"
readonly SCRIPT_DIR="$(dirname $SCRIPT_PATH)"

readonly DEBUG=false
readonly TEMP_DIR=$(mktemp --tmpdir -d 'gmr-check.XXX')
readonly TEMP_LATEST="$TEMP_DIR/latest"
readonly TEMP_FEED="$TEMP_DIR/feed-"

readonly CHECK_PAGESIZE=3

# fetch latest feeds
fetchLatestFeeds(){
  gmr owner-feeds 0 $CHECK_PAGESIZE > "$TEMP_LATEST"

  $DEBUG && {
    echo 'LATEST:' "$TEMP_LATEST"
    cat "$TEMP_LATEST"
  }
}

splitLatestFeeds(){
  "${SCRIPT_DIR}/gmr-splitFeeds.sh" "$TEMP_LATEST" "$TEMP_FEED"
}

copyNewFeeds(){
  for from in ${TEMP_FEED}*
  do
    local filename="${from##*/}"
    local to="${DIR_FEEDS}/${filename}"

    if [ ! -e "$to" ]; then
      cp "$from" "$to"
      {
        cat "$to" | jq -r '.body_text'
        cat "$to" | jq -r '.contents[].thumbnail' 
      }| slack-post -w "$SLACKPOST_ID" 
    fi
  done
}

################################

if [ ! -e $LOCK ]; then
  touch "$LOCK"
  fetchLatestFeeds
  splitLatestFeeds
  copyNewFeeds
  rm -f "$LOCK"
fi
