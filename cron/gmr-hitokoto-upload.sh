#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly HITOKOTO_DIR="$1"
readonly GDRIVE_UPLOAD_DIR="$2"
readonly SLACKPOST_ID="$3"

readonly TEMP_UPLOAD_OUTPUT=$(mktemp --tmpdir)
readonly TEMP_UPLOAD_LIST=$(mktemp --tmpdir)

# mkdir 
ls -1 "$HITOKOTO_DIR" | xargs -I{} skicka mkdir "${GDRIVE_UPLOAD_DIR%/}/{}"

# upload
(
  cd "$HITOKOTO_DIR"

  for dir in *
  do
    (
      cd "$dir"
      ls -1 | {
        while read file; do
          echo -n "$file "
          skicka upload "$file" "${GDRIVE_UPLOAD_DIR%/}/$dir/$file" 2>> $TEMP_UPLOAD_OUTPUT
  
          # find line of uploading: "Files:  5 B / 5 B [==========..."
          grep -P '^Files' $TEMP_UPLOAD_OUTPUT >/dev/null 2>/dev/null && {
	    echo "UPLOADED!"
            echo "$file" >> $TEMP_UPLOAD_LIST
          } || {
	    echo "SKIP"
          }
        done
      }
    )
  done
) 

if [ -s $TEMP_UPLOAD_LIST ]; then
  {
    echo "今日のヒトコト UPLOAD:"
    cat $TEMP_UPLOAD_LIST
  } | slack-post -w $SLACKPOST_ID
fi

