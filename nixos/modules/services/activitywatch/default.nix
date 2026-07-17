#
# Automatic time tracker: logs active window and AFK status to a local
# server with a timeline UI at http://localhost:5600.
#
{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.activitywatch;
in {
  options.eclipse.activitywatch = {
    enable = mkEnableOption "ActivityWatch time tracking";

    syncDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Directory aw-sync mirrors the event databases into. Sync is disabled when null.";
    };
  };

  config = mkIf cfg.enable {
    eclipse.hm = {
      config,
      osConfig,
      pkgs,
      ...
    }: {
      services.activitywatch = {
        enable = true;
        package = pkgs.aw-server-rust;
        # Single watcher covering both window titles and AFK detection on Wayland.
        watchers.awatcher.package = pkgs.awatcher;
      };

      # The incognito-marker extension in _config is loaded unpacked into
      # Chrome (with "Allow in incognito") directly from the repo checkout:
      # Chrome canonicalizes the path on load, so a nix store symlink would
      # pin a stale version.
      xdg.configFile."awatcher/config.toml".source = ./_config/awatcher-config.toml;

      systemd.user.services =
        {
          # awatcher talks to the compositor, so it fails until the Wayland
          # session is up; the home-manager module starts it at default.target.
          activitywatch-watcher-awatcher = {
            Unit.After = ["graphical-session.target"];
            Service = {
              Restart = "on-failure";
              RestartSec = 10;
            };
          };
        }
        // optionalAttrs osConfig.eclipse.niri.enable {
          activitywatch-watcher-niri-workspace = {
            Unit = {
              Description = "ActivityWatch watcher for the focused Niri workspace";
              After = ["graphical-session.target" "activitywatch.service"];
              BindsTo = ["activitywatch.target"];
            };
            Service = {
              ExecStart = "${pkgs.python3.interpreter} ${./_config/aw-watcher-niri-workspace.py} ${getExe config.programs.niri.package}";
              Restart = "on-failure";
              RestartSec = 10;
            };
            Install.WantedBy = ["activitywatch.target"];
          };
        }
        // optionalAttrs (cfg.syncDir != null) {
          activitywatch-sync = {
            Unit = {
              Description = "ActivityWatch sync daemon";
              After = ["activitywatch.service"];
              BindsTo = ["activitywatch.target"];
            };
            Service = {
              ExecStart = "${getExe' pkgs.aw-server-rust "aw-sync"} --sync-dir ${escapeShellArg cfg.syncDir} daemon";
              Restart = "on-failure";
              RestartSec = 60;
            };
            Install.WantedBy = ["activitywatch.target"];
          };
        };
    };
  };
}
