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
    # Set using secret: base_url = "https://vault.xilain.dev/"; # Optional, default is set
    # Set using secret: ui_url = "https://vault.xilain.dev/"; # Optional
    lock_timeout = "32400"; # Optional, default is 3600 seconds (1 hour), 32400 seconds (9 hours)
    sync_interval = "3600"; # Optional, default is 3600 seconds (1 hour)
    pinentry = "${pkgs.pinentry-gnome3}/bin/pinentry-gnome3"; # Optional, default is pinentry
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
    source ${config.sops.secrets."rbw-setup".path}
  '';
in {
  options = {
    rbw.enable = lib.mkEnableOption "Enables rbw";
  };

  config = lib.mkIf config.rbw.enable {
    home.packages = with pkgs; [
      pinentry-gnome3 # For passphrase input
      rbw
      setupRbwConfigScript
    ];

    sops.secrets."rbw-setup" = {
      sopsFile = ./../../../secrets/rbw-setup.sh;
      format = "binary";
    };

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
