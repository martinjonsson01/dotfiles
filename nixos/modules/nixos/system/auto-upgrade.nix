#
# Continuous automatic upgrades: a user timer updates flake.lock and commits
# it, then system.autoUpgrade rebuilds from the repo. Split this way because
# the nightly upgrade can't write a lock file into the read-only store copy
# of the flake, and root shouldn't touch the user-owned git repo.
#
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  flakeDir = "/home/martin/dotfiles/nixos";
  failureFlagDir = "/var/lib/auto-upgrade";
  failureFlag = "${failureFlagDir}/failed";
in {
  options = {
    auto-upgrade.enable = mkEnableOption "Enables continuous automatic upgrades";
  };

  config = mkIf config.auto-upgrade.enable {
    system.autoUpgrade = {
      enable = true;
      flake = flakeDir;
      flags = ["-L"];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };

    # Group-writable so the user's notify service can clear the flag.
    systemd.tmpfiles.rules = ["d ${failureFlagDir} 0775 root users -"];

    systemd.services.nixos-upgrade = {
      onFailure = ["nixos-upgrade-failure-flag.service"];
      # ExecStartPost only runs on success, so a surviving flag means failure.
      serviceConfig.ExecStartPost = "${pkgs.coreutils}/bin/rm -f ${failureFlag}";
    };

    systemd.services.nixos-upgrade-failure-flag = {
      description = "Flag failed auto-upgrade for user notification";
      serviceConfig.Type = "oneshot";
      script = "touch ${failureFlag}";
    };

    systemd.user.services.flake-update = {
      description = "Update flake.lock and commit it";
      path = [pkgs.git config.nix.package];
      environment.SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
      serviceConfig.Type = "oneshot";
      onFailure = ["upgrade-failure-notify.service"];
      script = ''
        cd ${flakeDir}
        nix flake update nixpkgs
        if ! git diff --quiet -- flake.lock; then
          git commit --message "Update nixpkgs" -- flake.lock
        fi
      '';
    };

    systemd.user.timers.flake-update = {
      wantedBy = ["timers.target"];
      timerConfig = {
        # An hour before the system upgrade so it picks up the new lock.
        OnCalendar = "01:00";
        Persistent = true;
        RandomizedDelaySec = "15min";
      };
    };

    systemd.user.services.upgrade-failure-notify = {
      description = "Notify user of failed auto-upgrade";
      serviceConfig.Type = "oneshot";
      # Clear the flag before notifying: if it survived, the path unit would
      # retrigger this service in an endless loop.
      script = ''
        rm -f ${failureFlag}
        ${pkgs.libnotify}/bin/notify-send --urgency=critical "NixOS auto-upgrade failed" \
          "See journalctl -u nixos-upgrade or journalctl --user -u flake-update"
      '';
    };

    # PathExists delivers failures that happened while logged out.
    systemd.user.paths.upgrade-failure-notify = {
      wantedBy = ["paths.target"];
      pathConfig = {
        PathExists = failureFlag;
        PathModified = failureFlag;
      };
    };
  };
}
