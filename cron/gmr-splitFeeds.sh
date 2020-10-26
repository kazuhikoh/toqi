#!/bin/bash

readonly INPUT_FILEPATH="$1"
readonly OUTPUT_FILEPATH="$2"

readonly TEMP_DIR="$(mktemp --tmpdir -d)"
readonly TEMP_FILENAME_PREFIX="feed-"

splitFeeds(){
  # split
  split -l 1 -d "${INPUT_FILEPATH}" "${TEMP_DIR}/${TEMP_FILENAME_PREFIX}"

  # rename
  for path in ${TEMP_DIR}/*
  do
    local filename=$(cat $path | jq -r '.article_date + "-" + (.article_no|tostring)' | sed 's/[\/ :]//g')
    mv $path "${OUTPUT_FILEPATH}${filename}.json"
  done
}

splitFeeds
