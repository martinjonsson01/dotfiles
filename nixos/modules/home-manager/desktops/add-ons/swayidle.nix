#
# This interface allows to monitor user idle time on a given seat.
# The interface allows to register timers which trigger after no
# user activity was registered on the seat for a given interval.
# It notifies when user activity resumes.
# This is useful for applications wanting to perform actions
# when the user is not interacting with the system,
# e.g. chat applications setting the user as away,
# power management features to dim screen, etc..
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    swayidle.enable = lib.mkEnableOption "Enables swayidle";
  };

  config = lib.mkIf config.swayidle.enable {
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          # Execute timeout command if there is no activity for seconds.
          timeout = 1800; # 30 minutes
          command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on"; # resume command will be run when there is activity again.
        }
      ];
      systemdTarget = "hyprland-session.target";
    };
  };
}
