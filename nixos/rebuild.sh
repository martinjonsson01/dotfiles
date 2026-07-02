#!/usr/bin/env bash

# Rebuild the flake host matching this machine's hostname.

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

pushd ~/dotfiles/nixos/

host=$(hostname)

alejandra -q .

# Shows your changes
git --no-pager diff --unified=0 '*.nix' '*.fish' '*.sh' '*.json' '*.txt' '*.lua' '*.py'

echo "NixOS Rebuilding $host..."

# Rebuild, output simplified errors, log tracebacks
if ! sudo nixos-rebuild switch --flake ".#$host" |& tee nixos-switch.log; then
  grep --color -A 100 error <nixos-switch.log
  notify-send -e "NixOS Rebuild failed!" --icon=dialog-error
  exit 1
fi

popd

notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
