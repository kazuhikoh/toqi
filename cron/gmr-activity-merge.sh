#!/bin/bash

# Merge new activities into TO_DIR/YYYY/MM/TO_PREFIX-{YYYYMMDDhhmmss}-{article_no}.json
readonly TO_DIR="$1"
readonly TO_PREFIX=$2

readonly tempdir="$(mktemp --tmpdir -d 'gmr-feed-check-merge.XXX')"

# split: stdin -> ???/activity_???
cat - | split -l 1 -d - "$tempdir/activity-"

# rename: ???/activity_??? -> TO_DIR/YYYY/MM/{TO_PREFIX}{YYYYMMDDhhmm}_{article_no}_{UUID}.json
for path in $tempdir/*
do
  subdir=$(
    cat $path \
      | jq -r '.activity_date' \
      | grep -oP '^.......'
  )
  filename=$(
    cat $path \
      | jq -r '.activity_date + "-" + (.article_no|tostring)' \
      | sed 's/[\/ :]//g'
  )
  uuid=$(
    cat /proc/sys/kernel/random/uuid
  )

  to="${TO_DIR}/${subdir}/${TO_PREFIX}${filename}_${uuid}.json"

  # checking file NOT exists which has same content
  hash=$(md5sum $path | cut -d " " -f 1)
  hash_found=$(md5sum "${TO_DIR}/${subdir}"/* | grep $hash)
  if [ -n "$hash_found" ]; then
    continue
  fi

  mkdir -p "${to%/*}"
  mv $path "$to"
done
