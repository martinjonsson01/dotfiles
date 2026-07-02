{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.eclipse.core;
in {
  options.eclipse.core.enable = mkEnableOption "Enables the core profile.";

  config = mkIf cfg.enable {
    eclipse = {
      auto-upgrade.enable = mkDefault true;
      btop.enable = mkDefault true;
      fish.enable = mkDefault true;
      gh.enable = mkDefault true;
      git.enable = mkDefault true;
      grub.enable = mkDefault true;
      kanata.enable = mkDefault true;
      neovim.enable = mkDefault true;
      resilio.enable = mkDefault true;
      searxng.enable = mkDefault true;
      ssh.enable = mkDefault true;
      yazi.enable = mkDefault true;
      ydotool.enable = mkDefault true;
      zellij.enable = mkDefault true;

      hm = {pkgs, ...}: {
        home.packages = with pkgs; [
          fd # Simple, fast and user-friendly alternative to find
          bat # Cat(1) clone with syntax highlighting and Git integration
          dust # Disk usage utility written in Rust
          dysk # Simple and easy to view disk usage
          jq # JSON parsing/querying
          yq # YAML parsing/querying
          ripgrep # Faster grep
          openssl_3 # Cryptography
          websocat # Connect to websockets
          ethtool # Utility for controlling network drivers and hardware
          curl # Command line tool for transferring files with URL syntax
          wget # Tool for retrieving files using HTTP, HTTPS, and FTP
        ];
      };
    };

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

    environment.sessionVariables.EDITOR = "nvim";
  };
}
