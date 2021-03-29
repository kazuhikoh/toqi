#!/bin/bash

: $1 $2

function dl() {
  url="$1"
  out="${2}.mp3"

  if [[ -e "$out" ]]; then
    echo "SKIP $out"
  else
    echo "GET  $out"
    curl -Ss "$url" > "$out"
  fi
}

export -f dl
gmr music-album -p $1 $2 | xargs -I{} bash -c 'dl {} {}'
