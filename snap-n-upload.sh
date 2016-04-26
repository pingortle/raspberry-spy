#!/bin/bash

PARENT_ID="0B8efFs0xIAAQdEM0WUdZZS04alE"
DATE=$(date +"%Y-%m-%d_%H%M%S")
MAX_MB=1024

SYNC_DIR="$HOME/monitor/snaps"
_FILENAME="$(basename $0)"
LOCK_FILENAME=".$_FILENAME-$PARENT_ID.lock"
LOCK_FILE="$HOME/$LOCK_FILENAME"

function truncateDir(){
  local dir_size=$(du -sm $SYNC_DIR | cut -f1)
  local max_size=$1
  while [ $(du -sm $SYNC_DIR | cut -f1) -gt "$max_size" ]
  do
    IFS= read -r -d $'\0' line < <(find $SYNC_DIR -maxdepth 1 -type f -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
    local file="${line#* }"
    echo "Deleting $file"
    rm "$file"
  done
}

SNAP_FILE=$SYNC_DIR/$DATE.jpg
echo "Snapping $SNAP_FILE"
raspistill -awb auto -ss 1250000 --ISO 1600 -o $SNAP_FILE &&
truncateDir $MAX_MB &&
echo "Locking..." &&
mkdir $LOCK_FILE &&
(
  $HOME/.bin/gdrive sync upload --delete-extraneous --keep-local $SYNC_DIR $PARENT_ID
  echo "Removing lock file..."
  rmdir $LOCK_FILE \
)
