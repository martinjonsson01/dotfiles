#!/usr/bin/env bash

YEAR=$(date +%Y) || exit
MONTH=$(date +%b) || exit
DAY=$(date +%d) || exit
TIME=$(date +'%H:%M:%S') || exit

TEMP_PATH="/tmp/screenshot-$YEAR-$MONTH-$DAY-$TIME.png"
FINAL_PATH="$HOME/Pictures/Screenshots/$YEAR/$MONTH/$DAY-$TIME.png"

mkdir -p $HOME/Pictures/Screenshots/$YEAR
mkdir -p $HOME/Pictures/Screenshots/$YEAR/$MONTH

# Take actual screenshot, store to temp path...
gnome-screenshot --file=$TEMP_PATH "$@" || exit

# If screenshot was canceled, exit.
if [ ! -f $TEMP_PATH ]; then
  echo "Screenshot canceled"
  exit
fi

# Edit with swappy, save as file and copy to clipboard.
swappy -f $TEMP_PATH -o - | tee $FINAL_PATH | wl-copy

# Clean up temp file.
rm $TEMP_PATH
