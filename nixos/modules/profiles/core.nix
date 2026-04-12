{
  lib,
  config,
  pkgs,
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
    searxng.enable = true;

    security.sudo = {
      enable = true;
      configFile = ''
        Defaults timestamp_timeout=30
      '';
    };

    # Ensure numlock is enabled on boot.
    systemd.services.numLockOnTty = {
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        # /run/current-system/sw/bin/setleds -D +num < "$tty";
        ExecStart = lib.mkForce (
          pkgs.writeShellScript "numLockOnTty" ''
            for tty in /dev/tty{1..6}; do
                ${pkgs.kbd}/bin/setleds -D +num < "$tty";
            done
          ''
        );
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # To enable wayland support in e.g. Slack
    environment.sessionVariables.EDITOR = "nvim";

    sops.secrets."gemini-api-key" = {
      sopsFile = ./../../secrets/api.yaml;
      owner = "martin";
    };

    sops.secrets."deepseek-api-key" = {
      sopsFile = ./../../secrets/api.yaml;
      owner = "martin";
    };

    sops.secrets."openrouter-api-key" = {
      sopsFile = ./../../secrets/api.yaml;
      owner = "martin";
    };

    home-manager.users.martin = {
    };
  };
}
