{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options = {
    niri.enable = lib.mkEnableOption "Enables Niri";
  };

  config = lib.mkIf config.niri.enable {
    # Nix packages configure Chrome and Electron apps to run in native Wayland
    # mode if this environment variable is set.
    home.sessionVariables.NIXOS_OZONE_WL = "1";
    home.packages = with pkgs; [
      kitty # Terminal emulator
      fuzzel # Application launcher
      swaylock # Lock screen
      xwayland-satellite # X11 compatibility
    ];

    programs.niri =
      {
        enable = true;
      }
      // (import ./config {inherit config lib pkgs osConfig;});
  };
}
