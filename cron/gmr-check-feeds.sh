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
readonly TEMP_FEED="$TEMP_DIR/feed-"

readonly CHECK_PAGESIZE=3

# fetch latest feeds
fetchLatestFeeds(){
  gmr feeds 1 0 $CHECK_PAGESIZE > "$TEMP_LATEST"

  $DEBUG && {
    echo 'LATEST:' "$TEMP_LATEST"
    cat "$TEMP_LATEST"
  }
}

splitLatestFeeds(){
  local temp_split=$(mktemp --tmpdir -d 'tmp.gmr-check-feeds-split.XXX')
  split -l 1 -d "$TEMP_LATEST" "${temp_split}/feed-"

  for path in ${temp_split}/*
  do
    local filename=$(
      cat $path | jq -r '.article_date + "-" + (.article_no|tostring)' | sed 's/[\/ :]//g'
    )
    mv $path "${TEMP_FEED}${filename}.json"
  done

  rm -rf ${temp_split}
}

copyNewFeedsAndNotify(){
  mkdir -p "${DIR_FEEDS}" 2>/dev/null

  for from in ${TEMP_FEED}*
  do
    local filename="${from##*/}"
    local to="${DIR_FEEDS}/${filename}"

    if [ ! -e "$to" ]; then
      echo "SAVE ${filename}" >&2

      cp "$from" "$to"
      cat "$to" | "${SCRIPT_DIR}/gmr-feed-notify.sh" "$SLACKPOST_ID"
    else
      echo "SKIP ${filename}" >&2
    fi
  done
}

################################

if [ ! -e $LOCK ]; then
  touch "$LOCK"
  fetchLatestFeeds
  splitLatestFeeds
  copyNewFeedsAndNotify 
  rm -rf ${TEMP_DIR}
  rm -f "$LOCK"
fi
