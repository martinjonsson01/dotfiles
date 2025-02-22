{...}: {
  imports = [
    ./programs/git.nix
    ./programs/rbw.nix
    ./programs/vscode.nix
    ./desktops/gnome.nix
    ./desktops/autostart.nix
    ./launchers/rofi.nix
    ./launchers/rofi-rbw.nix
    ./shells/fish/fish.nix
  ];
}
