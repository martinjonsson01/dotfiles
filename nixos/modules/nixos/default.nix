{...}: {
  imports = [
    ./desktops/hyprland
    ./desktops/niri

    ./desktops/add-ons/polkit-gnome.nix

    ./system/nvidia.nix
    ./system/stylix.nix
    ./system/myHardware.nix

    ./programs/teamviewer.nix
    ./programs/steam.nix

    ./services/resilio.nix
    ./services/audio.nix

    ./shells/fish.nix
  ];
}
