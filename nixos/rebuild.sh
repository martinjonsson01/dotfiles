#!/usr/bin/env bash

# Taken from https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# A rebuild script that commits on a successful build

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# cd to your config dir
pushd ~/dotfiles/nixos/

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git --no-pager diff --unified=0 '*.nix' '*.fish' '*.sh' '*.json' '*.txt' '*.lua' '*.py'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --flake /home/martin/dotfiles/nixos#default |& tee nixos-switch.log || (grep --color -A 100 error < nixos-switch.log && exit 1)

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
