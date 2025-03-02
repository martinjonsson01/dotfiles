{
  pkgs,
  inputs,
  ...
}: [
  (import ./gnome-mutter.nix {inherit pkgs inputs;})
]
