#!/bin/bash

# Merge new feeds into TO_DIR/YYYY/MM/TO_PREFIX-{YYYYMMDDhhmmss}-{article_no}-{filehash}.json
readonly TO_DIR="$1"
readonly TO_PREFIX=$2

readonly TEMP_DIR="$(mktemp --tmpdir -d 'tmp.gmr-feed-merge.XXX')"

# split: stdin -> ???/feed-XXX
cat - | split -l 1 -d - "$TEMP_DIR/feed-"

# rename: ???/feed-XXX -> TO_DIR/YYYY/MM/{TO_PREFIX}{YYYYMMDDhhmmss}-{article_no}-{filehash}.json
for path in $TEMP_DIR/*
do
  subdir=$(
    cat $path \
      | jq -r '.article_date' \
      | grep -oP '^.......'
  )
  filename=$(cat $path | jq -r '.article_date + "-" + (.article_no|tostring)' | sed 's/[\/ :]//g')
  filehash=$(cat $path | jq -c '{body_text, contents}' | md5sum | grep -oP '^.{32}')

  to="${TO_DIR}/${subdir}/${TO_PREFIX}${filename}-${filehash}.json"

  if [ ! -e "$to" ]; then
    echo "SAVE ${to}" >&2
    mkdir -p "${to%/*}"
    mv $path "${to}"
    echo "${to}"
  else
    echo "SKIP ${to}" >&2
  fi
done

rm -rf $TEMP_DIR

