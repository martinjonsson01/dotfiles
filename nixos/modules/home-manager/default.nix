{...}: {
  imports = [
    ./programs/git.nix
    ./programs/rbw.nix
    ./programs/vscode.nix
    ./desktops/gnome.nix
    ./launchers/rofi.nix
    ./launchers/rofi-rbw.nix
    ./services/ydotool.nix
  ];
}
