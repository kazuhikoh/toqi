#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly HITOKOTO_DIR="$1"
readonly GDRIVE_UPLOAD_DIR="$2"
readonly SLACKPOST_ID="$3"

{
  echo "src:$HITOKOTO_DIR" >&2
  echo "dst:$GDRIVE_UPLOAD_DIR" >&2 

  cd "$HITOKOTO_DIR"

  for dir in $(ls -1)
  do
    echo "check ${HITOKOTO_DIR%/}/$dir" >&2

    # Skip this month or future
    dir_y=$(echo "$dir" | grep -oP '[0-9]+(?=年)')
    dir_m=$(echo "$dir" | grep -oP '[0-9]+(?=月)')
    now_y=$(date '+%Y')
    now_m=$(date '+%-m')
    if (( $dir_y > $now_y )) || (( $dir_y == $now_y && $dir_m >= $now_m )); then
      echo "$dir SKIP"
      echo "$dir SKIP" >&2
      continue
    fi  

    diff_cnt=$(
      rclone check "${HITOKOTO_DIR%/}/$dir" ${GDRIVE_UPLOAD_DIR%/}/$dir --one-way 2>&1 \
	      | grep -oP '[^ ]+(?= differences found)'  
    )

    if [ "$diff_cnt" != 0 ]; then
      echo "$dir KEEP(diff=$diff_cnt)"
      echo "$dir KEEP(diff=$diff_cnt)" >&2
    else
      echo "$dir CLEAN" 
      echo "$dir CLEAN" >&2
      rm -rf "$dir"
    fi
    
  done
} | slack-post -w $SLACKPOST_ID

