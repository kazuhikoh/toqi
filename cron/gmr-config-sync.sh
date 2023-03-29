#!/bin/bash

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/.npm-global/bin

readonly SLACKPOST_ID="$1"

{
  rclone copy gdrive:1091 ~/ --include /.gmr-config.json --verbose 2>&1 \
	  | grep 'Copied' 

  # < No difference >
  # 2023/03/29 14:36:41 INFO  : There was nothing to transfer
  # 2023/03/29 14:36:41 INFO  :
  # Transferred:   	          0 B / 0 B, -, 0 B/s, ETA -
  # Checks:                 1 / 1, 100%
  # Elapsed time:         2.5s
  #
  # < Updated >  
  # 2023/03/29 14:38:03 INFO  : .gmr-config.json: Copied (replaced existing)
  # 2023/03/29 14:38:03 INFO  :
  # Transferred:   	    1.674 KiB / 1.674 KiB, 100%, 0 B/s, ETA -
  # Checks:                 1 / 1, 100%
  # Transferred:            1 / 1, 100%
  # Elapsed time:         3.4s
  # 
} | slack-post -w $SLACKPOST_ID


