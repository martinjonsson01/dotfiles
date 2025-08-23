{...}: {
  imports = [
    ./programs/git
    ./programs/rbw.nix
    ./programs/vscode.nix
    ./programs/satty.nix
    ./programs/plex
    ./programs/btop.nix
    ./programs/zoom.nix
    ./programs/pinta.nix
    ./programs/qalculate.nix
    ./programs/kitty.nix
    ./programs/nemo.nix
    ./programs/jetbrains.nix
    ./programs/totem.nix
    ./programs/decibels.nix
    ./programs/mpv.nix
    ./programs/loupe.nix
    ./programs/flameshot.nix
    ./programs/lutris.nix
    ./programs/zellij.nix

    ./desktops/gnome
    ./desktops/hyprland
    ./desktops/niri
    ./desktops/autostart.nix

    ./desktops/add-ons/dunst.nix
    ./desktops/add-ons/swaync.nix
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
    ./desktops/add-ons/fuzzel.nix
    ./desktops/add-ons/cliphist
    ./desktops/add-ons/copyq

    ./launchers/rofi.nix
    ./launchers/rofi-rbw.nix

    ./shells/fish/fish.nix

    ./editors/neovim

    ./scripts/screenrecord-region.nix
    ./scripts/screenshot-region.nix
    ./scripts/open-screenshot-dir.nix
    ./scripts/search-google.nix
    ./scripts/search-github-nix.nix

    ./themes/tokyonight.nix
  ];
}
