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
readonly TEMP_DIR=$(mktemp --tmpdir -d 'tmp.gmr-check-feeds.XXX')
readonly TEMP_LATEST="$TEMP_DIR/latest"
readonly TEMP_NEWFEEDS="$TEMP_DIR/new_feeds"

readonly CHECK_PAGESIZE=3

# fetch latest feeds -> $TEMP_LATEST
fetchLatestFeeds(){
  gmr feeds 1 0 $CHECK_PAGESIZE > "$TEMP_LATEST"

  $DEBUG && {
    echo 'LATEST:' "$TEMP_LATEST" >&2
    cat "$TEMP_LATEST"
  }
}

# merge $TEMP_LATEST -> $DIR_FEEDS/YYYY/MM/feed-*.json
mergeLatestFeeds(){
  cat "$TEMP_LATEST" \
    | "${SCRIPT_DIR}/gmr-feed-merge.sh" "${DIR_FEEDS}" "feed-" >"$TEMP_NEWFEEDS"
}

notifyNewFeeds() {
  for f in $(cat $TEMP_NEWFEEDS)
  do
    cat $f | "${SCRIPT_DIR}/gmr-feed-notify.sh" "$SLACKPOST_ID"
  done
}

################################

if [ ! -e $LOCK ]; then
  touch "$LOCK"
  fetchLatestFeeds
  mergeLatestFeeds
  notifyNewFeeds
  rm -rf $TEMP_DIR
  rm -f "$LOCK"
fi
