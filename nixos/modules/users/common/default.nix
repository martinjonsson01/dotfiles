{...}: {
  imports = [
    ./programs/git
    ./programs/gh.nix
    ./programs/vscode.nix
    ./programs/satty.nix
    ./programs/plex
    ./programs/btop.nix
    ./programs/zoom.nix
    ./programs/pinta.nix
    ./programs/qalculate.nix
    ./programs/kitty.nix
    ./programs/jetbrains.nix
    ./programs/decibels.nix
    ./programs/mpv.nix
    ./programs/loupe.nix
    ./programs/lutris.nix
    ./programs/zellij
    ./programs/podman.nix
    ./programs/gdb-dashboard.nix
    ./programs/ssh.nix
    ./programs/yazi.nix
    ./programs/ollama.nix
    ./programs/open-webui.nix
    ./programs/easyeffects
    ./programs/mic-default-mute.nix
    ./programs/handy.nix

    ./desktops/niri

    ./desktops/add-ons/swaync.nix
    ./desktops/add-ons/blueman-applet.nix
    ./desktops/add-ons/gtk-theme.nix
    ./desktops/add-ons/swaylock
    ./desktops/add-ons/nwg-bar.nix
    ./desktops/add-ons/nm-applet.nix
    ./desktops/add-ons/pasystray.nix
    ./desktops/add-ons/swayidle.nix
    ./desktops/add-ons/waybar.nix
    ./desktops/add-ons/fuzzel.nix
    ./desktops/add-ons/cliphist
    ./desktops/add-ons/copyq

    ./shells/fish/fish.nix

    ./editors/neovim

    ./scripts/screenrecord-region.nix
    ./scripts/screenshot-region.nix
    ./scripts/open-screenshot-dir.nix
    ./scripts/search-google.nix
    ./scripts/search-github-nix.nix
    ./scripts/niri-rename-workspace.nix
    ./scripts/niri-launch-kitty-workspace-cwd.nix
    ./scripts/lock-script.nix

    ./themes/tokyonight.nix
  ];
}
