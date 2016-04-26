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
  if [ $(du -sm $SYNC_DIR | cut -f1) -gt "$max_size" ]
  then
    IFS= read -r -d $'\0' line < <(find $SYNC_DIR -maxdepth 1 -type f -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
    local file="${line#* }"
    echo $file
    rm "$file"
  fi
}

echo "Locking $DATE..."
test ! -f $LOCK_FILE && echo "$DATE" > $LOCK_FILE ||
echo "Can't lock $DATE. Already locked for $(cat $LOCK_FILE)."

raspistill -awb auto -ss 2500000 --ISO 800 -o $SYNC_DIR/$DATE.jpg &&
truncateDir $MAX_MB &&
test -f "$LOCK_FILE" &&
test "$(cat $LOCK_FILE)" = "$DATE" &&
(
  $HOME/.bin/gdrive sync upload --delete-extraneous --keep-local $SYNC_DIR $PARENT_ID
  echo "Removing lock file $(cat $LOCK_FILE)..."
  rm $LOCK_FILE \
)
