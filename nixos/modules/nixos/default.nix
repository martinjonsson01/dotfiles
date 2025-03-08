{...}: {
  imports = [
    ./desktops/hyprland/default.nix

    ./desktops/add-ons/polkit-gnome.nix

    ./system/nvidia.nix
    ./system/stylix.nix
    ./system/myHardware.nix

    ./services/resilio.nix
    ./services/audio.nix

    ./shells/fish.nix
  ];
}
