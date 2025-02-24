{...}: {
  imports = [
    ./programs/git.nix
    ./programs/rbw.nix
    ./programs/vscode.nix
    ./programs/satty.nix

    ./desktops/gnome.nix
    ./desktops/hyprland/default.nix
    ./desktops/autostart.nix

    ./desktops/add-ons/dunst.nix
    ./desktops/add-ons/blueman-applet.nix
    ./desktops/add-ons/gtk-theme.nix
    ./desktops/add-ons/swaylock
    ./desktops/add-ons/nwg-bar.nix

    ./launchers/rofi.nix
    ./launchers/rofi-rbw.nix

    ./shells/fish/fish.nix
  ];
}
