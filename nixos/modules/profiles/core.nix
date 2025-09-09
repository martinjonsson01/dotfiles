{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.Eclipse.core;
in {
  options.Eclipse.core.enable = mkEnableOption "Enables the core profile.";

  config = mkIf cfg.enable {
    fish.enable = true;
    audio.enable = true;
    niri.enable = true;
    thunar.enable = true;
    ydotool.enable = true;
    sunsetr.enable = true;
    kanata.enable = true;
    resilio.enable = true;
    polkit-gnome.enable = true;

    # To enable wayland support in e.g. Slack
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    home-manager.users.martin = {
    };
  };
}
