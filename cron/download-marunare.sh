#!/bin/bash


PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly OUT_DIR="$1"
readonly SLACKPOST_ID="$2"
readonly SLACKPOST_CH="$3"

cd "$OUT_DIR"
hibikiradio download sora 'marunare.${program.episode.updated_at.slice(0,10).replace(/\//g,"")}.archive.mp4'
exitcode=$?

{
	echo "(⊃＾ω＾)⊃ DOWNLOAD: 徳井青空のまぁるくなぁれ！ (アーカイブ)"
	if [[ $exitcode -eq 0 ]]; then
		echo "--> OK"
	else
		echo "--> NG"
	fi

	echo "--------"
	ls -alF "${OUT_DIR}"
	echo "--------"
} | slack-post -w "$SLACKPOST_ID" -c "$SLACKPOST_CH"
