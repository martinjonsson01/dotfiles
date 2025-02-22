{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs/git.nix
    ./programs/rbw.nix
    ./programs/vscode.nix
    ./desktops/gnome.nix
    ./launchers/rofi.nix
  ];
}
