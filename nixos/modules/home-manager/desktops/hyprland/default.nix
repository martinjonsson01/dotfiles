{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.kitty.enable = true; # required for the default Hyprland config

    # Hint Electron apps to use Wayland.
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    wayland.windowManager.hyprland =
      {
        enable = true;
      }
      // (import ./config {inherit config lib pkgs;});
  };
}
