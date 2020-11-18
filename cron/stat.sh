#!/bin/bash

# PATH ###############################

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

# VARIABLE ###############################

readonly DIR="$1"
readonly SLACKPOST_ID="$2"

readonly DIR_NOW="${DIR%/}/$(date '+%Y%m%d-%H%M%S')"
readonly FILEPATH_TWITTER="$DIR_NOW/twitter.json"
readonly FILEPATH_YOUTUBE="$DIR_NOW/youtube.json"
readonly FILEPATH_BILIBILI="$DIR_NOW/bilibili.json"
readonly FILEPATH_FANCLUB="$DIR_NOW/fc.json"

# FUNCTION ###############################

function stat_twitter() {
  local x=1
}

function stat_youtube() {
  curl -Ss 'https://www.youtube.com/channel/UCJ8Wj4izZCt1i9gdTXnbD_Q/videos' | grep -oP '(?<=window\["ytInitialData"\] = ){.*}(?=;)' > "$FILEPATH_YOUTUBE"

  local x1=$(cat "$FILEPATH_YOUTUBE" | jq -r .header.c4TabbedHeaderRenderer.subscriberCountText.simpleText)

  echo 'youtube) そらまるのチャンネル'
  echo "  ${x1}"
}

function stat_bilibili() {
  curl -Ss 'https://api.bilibili.com/x/relation/stat?vmid=524622683' > "$FILEPATH_BILIBILI"
  
  local x1=$(cat "$FILEPATH_BILIBILI" | jq '.data.follower')
  local x2=$(cat "$FILEPATH_BILIBILI" | jq '.data.following')
  local x3=$(cat "$FILEPATH_BILIBILI" | jq '.data.whisper')
  local x4=$(cat "$FILEPATH_BILIBILI" | jq '.data.black')
  
  echo 'bilibili) 德井青空-official'
  echo "  follower:  ${x1}"
  echo "  following: ${x2}"
  echo "  whisper:   ${x3}"
  echo "  black:     ${x4}"
}

function stat_fc() {
  local x=1
}

# EXECUTE ###############################

if [ ! -e "$DIR_NOW" ]; then
  mkdir -p "$DIR_NOW"
fi

{
  stat_twitter
  stat_youtube
  stat_bilibili
  stat_fc
} | slack-post -w "$SLACKPOST_ID"

