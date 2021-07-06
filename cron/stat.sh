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
readonly FILEPATH_FANCLUB_USERINFO="$DIR_NOW/fanclub-userinfo.json"

# FUNCTION ###############################

function stat_fanclub() {
  gmr user 1 > "$FILEPATH_FANCLUB_USERINFO"
  local x1=$(cat "$FILEPATH_FANCLUB_USERINFO" | jq .level)

  echo "ぐーもる荘: 開荘から ${x1} 日"
}

function stat_twitter() {
  echo "@tokui_sorangley: <<NOT IMPLEMENTED>>"
}

function stat_youtube() {
  #curl -Ss 'https://www.youtube.com/channel/UCJ8Wj4izZCt1i9gdTXnbD_Q/videos' | grep -oP '(?<=window\["ytInitialData"\] = ){.*}(?=;)' > "$FILEPATH_YOUTUBE"
  curl -Ss 'https://www.youtube.com/channel/UCJ8Wj4izZCt1i9gdTXnbD_Q/videos' | grep -oP '(?<=ytInitialData = ){.*}(?=;)' > "$FILEPATH_YOUTUBE"

  local x1=$(cat "$FILEPATH_YOUTUBE" | jq -r .header.c4TabbedHeaderRenderer.subscriberCountText.simpleText)

  echo "そらまるのチャンネル: ${x1}"
}

function stat_bilibili() {
  curl -Ss 'https://api.bilibili.com/x/relation/stat?vmid=524622683' > "$FILEPATH_BILIBILI"
  
  local x1=$(cat "$FILEPATH_BILIBILI" | jq '.data.follower')
  local x2=$(cat "$FILEPATH_BILIBILI" | jq '.data.following')
  local x3=$(cat "$FILEPATH_BILIBILI" | jq '.data.whisper')
  local x4=$(cat "$FILEPATH_BILIBILI" | jq '.data.black')
  
  echo "德井青空-official: "
  echo "  follower:  ${x1}"
  echo "  following: ${x2}"
  echo "  whisper:   ${x3}"
  echo "  black:     ${x4}"
}

# EXECUTE ###############################

if [ ! -e "$DIR_NOW" ]; then
  mkdir -p "$DIR_NOW"
fi

{
  stat_fanclub
  echo ""
  stat_twitter
  echo ""
  stat_youtube
  echo ""
  stat_bilibili
} | slack-post -w "$SLACKPOST_ID"

