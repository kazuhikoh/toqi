#!/bin/bash

PATH=$PATH:/usr/local/bin
PATH=$PATH:~/bin

readonly ERROR_FILEPATH="${1:-"/tmp/agrec-check.err"}"
readonly SLACKPOST_ID="$2"

readonly ERROR_FILEPATH_SUFFIX="-$(date '+%Y%m%d%H%M%S')"

# skip if error file exists
dir="${ERROR_FILEPATH%/*}"
f="${ERROR_FILEPATH##*/}"
if ls "$dir"| grep "$f" >/dev/null; then
  exit 0
fi

# agrec check
out="$(agrec -c)"

if [ $? -ne 0 ]; then
  echo "$out" >"${ERROR_FILEPATH}${ERROR_FILEPATH_SUFFIX}"

  {
    echo "(⊃＾ω＾)⊃ AGQR RECORDING CHECK"
    echo "$out"
  } | slack-post -w "$SLACKPOST_ID"
fi

