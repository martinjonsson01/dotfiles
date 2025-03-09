#!/usr/bin/env bash

DATE=$(date +'%Y-%m-%d-%H:%M:%S') || exit
gnome-screenshot --file="$HOME/Pictures/Screenshots/$DATE.png" --clipboard "$@"