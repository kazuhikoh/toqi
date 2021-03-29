#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly DIR_ROOT="$1"
readonly SLACKPOST_ID="$2"

mkdir "$DIR_ROOT"
{
  cd "$DIR_ROOT"
  gmr music-albums -p 0 0 2 \
    | sed 's/ /_/g' \
    | sed 's/_/ /' \
    | sed 's/_/ /' \
    | xargs -n3 bash -c 'echo $2; mkdir -p $2; cd $2; hitokoto-dl $0 $1;'
} >&2

{
  cd "$DIR_ROOT" 
  ls -1 | xargs -I{} bash -c "echo -n {}' '; ls {} | wc -l"
} | slack-post -w "$SLACKPOST_ID"




