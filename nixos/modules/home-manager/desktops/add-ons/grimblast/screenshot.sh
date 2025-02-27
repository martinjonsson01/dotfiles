#!/usr/bin/env bash

mkdir -p ~/Pictures/Screenshots/$(date +%Y)
mkdir -p ~/Pictures/Screenshots/$(date +%Y)/$(date +%b)

echo 'grimblast save $1 - | swappy -f - -o - | tee ~/Pictures/Screenshots/$(date +%Y)/$(date +%b)/screenshot-$(date +%H:%M:%S).png | wl-copy'

grimblast save $1 - | swappy -f - -o - | tee ~/Pictures/Screenshots/$(date +%Y)/$(date +%b)/screenshot-$(date +%H:%M:%S).png | wl-copy
