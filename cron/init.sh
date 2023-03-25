#!/bin/bash

{
  echo '⊂(起＾ω＾動)⊃'
  echo ''

  # IP address
  echo '```'
  ip addr | grep inet | sed -r 's/^ +//g' | cut -d ' ' -f '1-2'
  echo '```'

  #ip addr | grep inet | sed -r 's/^ +//g' | cut -d ' ' -f '1-2' \
  #  | sed -r 's/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,3})/\`\1\`/g' 
} | slack-post -w log

# Clean lock files
rm ~/Downloads/1091/gu-morusou/.lock_*

