#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly DIR_ROOT="$1"
readonly SLACKPOST_ID=$2

{
  echo "TO: $DIR_ROOT"
  if [ ! -d "$DIR_ROOT" ]; then
    mkdir -p "$DIR_ROOT"
  fi
} >&2

{
  cd "$DIR_ROOT"

  gmr music-albums -p 0 0 2 \
    | sed 's/ /_/g' \
    | sed 's/_/ /' \
    | sed 's/_/ /' \
    | while read id1 id2 title
      do
        echo "$title"
        (
          mkdir -p "$title"
          cd "$title"

          gmr music-album -p $id1 $id2 \
            | while read url track
              do
                out="${track}.mp3"
                if [[ -e "$out" ]]; then
                  echo "SKIP $out"
                else
                  echo "GET  $out"
                  curl -Ss "$url" > "$out"
                fi
              done
        )
      done
} >&2

# Output
{
  cd "$DIR_ROOT" 
  ls -1 | xargs -I{} bash -c "echo -n {}' '; ls {} | wc -l"
} | slack-post -w "$SLACKPOST_ID"

