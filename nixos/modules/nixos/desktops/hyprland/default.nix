{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./binds.nix
    ./plugins.nix
  ];

  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    # For the (required) NixOS Module: enables critical components needed to run Hyprland properly.
    programs.hyprland.enable = true;

    home-manager.users."martin" = {
      programs.kitty.enable = true; # required for the default Hyprland config

      # Hint Electron apps to use Wayland.
      home.sessionVariables.NIXOS_OZONE_WL = "1";

      wayland.windowManager.hyprland = {
        enable = true;

        settings = {
          env = lib.optionals (config.nvidia.enable) [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          ];
        };
      };
    };
  };
}
