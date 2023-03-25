#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly HITOKOTO_DIR="$1"
readonly GDRIVE_UPLOAD_DIR="$2"
readonly SLACKPOST_ID="$3"

{
  echo "今日のヒトコト UPLOAD"
  rclone copy "$HITOKOTO_DIR" "$GDRIVE_UPLOAD_DIR" --verbose 2>&1
} | slack-post -w $SLACKPOST_ID

