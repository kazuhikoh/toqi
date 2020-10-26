#!/bin/bash

PATTH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly OUT_DIR="$1"
readonly SLACKPOST_ID="$2"
readonly SLACKPOST_CH="$3"

# 01 main
radiru download 5727 01 "${OUT_DIR%/}/"'anigechu.${file.aa_vinfo4.slice(0,16).replace(/[-:]/g,"").replace(/T/,"-")}.mp3'

# 02 omake
radiru download 5727 02 "${OUT_DIR%/}/"'anigechu.${file.aa_vinfo3}.${file.file_id}.${file.file_title.replace(/ /g, "_").replace(/\//g, "-")}.mp3'

# 03 omake?
#radiru download 5727 03 "${OUT_DIR%/}/"'anigechu.${file.aa_vinfo3}.${file.file_id}.${file.file_title.replace(/ /g, "_").replace(/\//g, "")}.mp3'
