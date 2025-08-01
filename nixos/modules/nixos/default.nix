{...}: {
  imports = [
    ./desktops/hyprland
    ./desktops/niri

    ./desktops/add-ons/polkit-gnome.nix

    ./system/nvidia.nix
    ./system/stylix.nix
    ./system/myHardware.nix
    ./system/plymouth.nix
    ./system/grub.nix

    ./programs/teamviewer.nix
    ./programs/steam.nix
    ./programs/nautilus.nix
    ./programs/thunar.nix

    ./services/resilio.nix
    ./services/audio.nix
    ./services/ydotool.nix
    ./services/sunsetr

    ./shells/fish.nix
  ];
}
