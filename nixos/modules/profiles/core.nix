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

    security.sudo = {
      enable = true;
      configFile = ''
        Defaults timestamp_timeout=30
      '';
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # To enable wayland support in e.g. Slack
    environment.sessionVariables.EDITOR = "nvim";

    programs.ssh.startAgent = true;

    home-manager.users.martin = {
    };
  };
}
