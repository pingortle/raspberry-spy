#!/bin/bash

PARENT_ID="0B8efFs0xIAAQdEM0WUdZZS04alE"
DATE=$(date +"%Y-%m-%d_%H%M%S")
LOCK=$(date +"%s%N")
MAX_MB=1024

SYNC_DIR="$HOME/monitor/snaps"
_FILENAME="$(basename $0)"
LOCK_FILENAME=".$_FILENAME-$PARENT_ID.lock"
LOCK_FILE="$HOME/$LOCK_FILENAME"

function truncateDir(){
  local dir_size=$(du -sm $SYNC_DIR | cut -f1)
  local max_size=$1
  if [ $(du -sm $SYNC_DIR | cut -f1) -gt "$max_size" ]
  then
    IFS= read -r -d $'\0' line < <(find $SYNC_DIR -maxdepth 1 -type f -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
    local file="${line#* }"
    echo "Deleting $file"
    rm "$file"
  fi
}

echo "Locking $LOCK..."
test ! -f $LOCK_FILE && echo "$LOCK" > $LOCK_FILE ||
echo "Can't lock $LOCK. Already locked for $(cat $LOCK_FILE)."

SNAP_FILE=$SYNC_DIR/$DATE.jpg
echo "Snapping $SNAP_FILE"
raspistill -awb auto -ss 1250000 --ISO 1600 -o $SNAP_FILE &&
truncateDir $MAX_MB &&
test -f "$LOCK_FILE" &&
test "$(cat $LOCK_FILE)" = "$LOCK" &&
(
  $HOME/.bin/gdrive sync upload --delete-extraneous --keep-local $SYNC_DIR $PARENT_ID
  echo "Removing lock file $(cat $LOCK_FILE)..."
  rm $LOCK_FILE \
)
