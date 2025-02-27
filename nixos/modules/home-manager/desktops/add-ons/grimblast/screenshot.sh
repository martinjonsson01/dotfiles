#!/usr/bin/env bash

mkdir -p ~/Pictures/Screenshots/$(date +%Y)
mkdir -p ~/Pictures/Screenshots/$(date +%Y)/$(date +%b)

grimblast save $0 - | swappy -f - -o - | tee ~/Pictures/Screenshots/$(date +%Y)/$(date +%b)/screenshot-$(date +%H:%m).png | wl-copy
