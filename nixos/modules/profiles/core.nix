{
  pkgs,
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
    plymouth.enable = true;
    ydotool.enable = true;
    sunsetr.enable = true;
    kanata.enable = true;
    resilio.enable = true;
    polkit-gnome.enable = true;

    home-manager.users.martin = {
    };
  };
}
