#!/bin/bash

: $1 $2

gmr music-album -p $1 $2 | awk '{printf "curl %s > %s.mp3\n", $1, $2}' | xargs -I{} bash -c '{}'
