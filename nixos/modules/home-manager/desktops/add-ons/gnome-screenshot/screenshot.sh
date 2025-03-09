#!/usr/bin/env bash

YEAR=$(date +%Y) || exit
MONTH=$(date +%b) || exit
TIME=$(date +'%H:%M:%S') || exit

mkdir -p $HOME/Pictures/Screenshots/$YEAR
mkdir -p $HOME/Pictures/Screenshots/$YEAR/$MONTH

gnome-screenshot --file="$HOME/Pictures/Screenshots/$YEAR/$MONTH/$TIME.png" --clipboard "$@"
