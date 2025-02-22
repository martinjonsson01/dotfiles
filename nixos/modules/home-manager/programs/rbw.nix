#
# RBW - Bitwarden CLI
#
{
  pkgs,
  lib,
  config,
  ...
}: let
  rbwConfig = {
    email = "martinjonsson01@gmail.com"; # Required
    sso_id = ""; # Optional, leave empty if not using SSO
    base_url = "https://vault.${config.sops.secrets."domain"}/"; # Optional, default is set
    ui_url = "https://vault.${config.sops.secrets."domain"}/"; # Optional
    lock_timeout = "32400"; # Optional, default is 3600 seconds (1 hour), 32400 seconds (9 hours)
    sync_interval = "3600"; # Optional, default is 3600 seconds (1 hour)
    # pinentry = "${pkgs.pinentry-gnome3}/bin/pinentry-gnome3"; # Optional, default is pinentry
  };

  # Convert the configuration to the format expected by rbw
  rbwConfigText =
    lib.concatStringsSep
    "\n"
    (
      lib.mapAttrsToList
      (name: value: ''rbw config set ${name} "${value}"'')
      rbwConfig
    );

  # Script to apply configuration
  setupRbwConfigScript = pkgs.writeShellScriptBin "setup-rbw-config" ''
    #!/usr/bin/env bash
    ${rbwConfigText}
  '';
in {
  options = {
    rbw.enable = lib.mkEnableOption "Enables rbw";
  };

  config = lib.mkIf config.rbw.enable {
    home.packages = with pkgs; [
      rbw
      setupRbwConfigScript
    ];

    # Ensure the script is executed to apply the configuration
    systemd.user.services.rbw-config = {
      Unit = {
        Description = "Configure rbw (Bitwarden CLI)";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${setupRbwConfigScript}/bin/setup-rbw-config";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
