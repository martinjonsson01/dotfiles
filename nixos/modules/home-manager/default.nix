{...}: {
  imports = [
    ./programs/git.nix
    ./programs/rbw.nix
    ./programs/vscode.nix
    ./programs/satty.nix
    ./programs/plex
    ./programs/btop.nix
    ./programs/zoom.nix

    ./desktops/gnome
    ./desktops/hyprland
    ./desktops/autostart.nix

    ./desktops/add-ons/dunst.nix
    ./desktops/add-ons/blueman-applet.nix
    ./desktops/add-ons/gtk-theme.nix
    ./desktops/add-ons/swaylock
    ./desktops/add-ons/nwg-bar.nix
    ./desktops/add-ons/nm-applet.nix
    ./desktops/add-ons/pasystray.nix
    ./desktops/add-ons/swayidle.nix
    ./desktops/add-ons/waybar.nix
    ./desktops/add-ons/hyprsunset.nix
    ./desktops/add-ons/grimblast
    ./desktops/add-ons/gnome-screenshot
    ./desktops/add-ons/hypridle.nix

    ./launchers/rofi.nix
    ./launchers/rofi-rbw.nix

    ./shells/fish/fish.nix
  ];
}
