#!/bin/bash

# 01 archive
radiru download 5727 01 'anigechu.${file.aa_vinfo4.slice(0,16).replace(/[-:]/g,"").replace(/T/,"-")}.mp3'

# 02 omake
radiru download 5727 02 'anigechu.${file.aa_vinfo3}.${file.file_id}.${file.file_title.replace(/ /g, "_").replace(/\//g, "-")}.mp3'

# 03 omake
#radiru download 5727 03 'anigechu.${file.aa_vinfo3}.${file.file_id}.${file.file_title.replace(/ /g, "_").replace(/\//g, "")}.mp3'
