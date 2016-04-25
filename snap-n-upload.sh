#!/bin/bash

PARENT_ID="0B8efFs0xIAAQNlVVc2U1dlhRbWc"
DATE=$(date +"%Y-%m-%d_%H%M%S")
MAX_MB=1024

SYNC_DIR="$HOME/monitor/snaps"

function truncateDir(){
  local dir_size=$(du -sm $SYNC_DIR | cut -f1)
  local max_size=$1
  if [ $(du -sm $SYNC_DIR | cut -f1) -gt "$max_size" ]
  then
    IFS= read -r -d $'\0' line < <(find $SYNC_DIR -maxdepth 1 -type f -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
    local file="${line#* }"
    echo $file
    rm "$file"
  fi
}

raspistill -awb auto -ss 2500000 --ISO 800 -o $SYNC_DIR/$DATE.jpg &&
truncateDir $MAX_MB &&
$HOME/.bin/gdrive sync upload --delete-extraneous --keep-local $SYNC_DIR $PARENT_ID
