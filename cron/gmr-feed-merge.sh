#!/bin/bash

# Merge new feeds into TO_DIR/YYYY/MM/TO_PREFIX-{YYYYMMDDhhmmss}-{article_no}.json
readonly TO_DIR="$1"
readonly TO_PREFIX=$2

readonly tempdir="$(mktemp --tmpdir -d 'gmr-feed-check-merge.XXX')"

# split: stdin -> ???/feed-XXX
cat - | split -l 1 -d - "$tempdir/feed-"

# rename: ???/feed-XXX -> TO_DIR/YYYY/MM/TO_PREFIX-{YYYYMMDDhhmmss}-{article_no}.json
for path in $tempdir/*
do
  subdir=$(
    cat $path \
      | jq -r '.article_date' \
      | grep -oP '^.......'
  )
  filename=$(cat $path | jq -r '.article_date + "-" + (.article_no|tostring)' | sed 's/[\/ :]//g')

  to="${TO_DIR}/${subdir}/${TO_PREFIX}${filename}.json"

  if [ ! -e "$to" ]; then
    echo "SAVE ${to}"
    mkdir -p "${to%/*}"
    mv $path "${to}"
  else
    echo "SKIP ${to}"
  fi
done

