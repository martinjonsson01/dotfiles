{...}: {
  imports = [
    ./programs/git.nix
    ./programs/rbw.nix
    ./programs/vscode.nix
    ./programs/satty.nix
    ./desktops/gnome.nix
    ./desktops/hyprland/default.nix
    ./desktops/autostart.nix
    ./launchers/rofi.nix
    ./launchers/rofi-rbw.nix
    ./shells/fish/fish.nix
  ];
}
