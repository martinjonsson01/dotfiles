#
# hyprsunset is a small utility to provide a blue light filter for your system.
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  startTime = "19:00:00";
  endTime = "05:00:00";
  temperature = 3000;
in {
  options = {
    hyprsunset.enable = lib.mkEnableOption "Enables hyprsunset";
  };

  config = lib.mkIf config.hyprsunset.enable {
    home.packages = [pkgs.hyprsunset];

    systemd.user = {
      services.hyprshade = {
        Unit = {
          Description = "Apply blue light filter";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t ${toString temperature}";
        };
      };
      timers.hyprshade = {
        Unit = {
          Description = "Apply blue light filter on schedule";
        };
        Timer = {
          OnCalendar = [
            "*-*-* ${endTime}"
            "*-*-* ${startTime}"
          ];
        };
        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };
}
