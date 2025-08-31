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
}:
with lib; {
  options = {
    swayidle.enable = mkEnableOption "Enables swayidle";
  };

  config = mkIf config.swayidle.enable {
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          # Execute timeout command if there is no activity for seconds.
          timeout = 60 * 30;
          command =
            if config.hyprland.enable
            then "${getExe pkgs.hyprland} dispatch dpms off"
            else if config.niri.enable
            then "${getExe pkgs.niri} msg action power-off-monitors"
            else "";
          # resume command will be run when there is activity again.
          resumeCommand =
            if config.hyprland.enable
            then "${getExe pkgs.hyprland} dispatch dpms on"
            else "";
        }
      ];
      systemdTarget =
        if config.hyprland.enable
        then "hyprland-session.target"
        else "";
    };
    systemd.user.services.swayidle.Unit.WantedBy =
      if config.niri.enable
      then "niri.service"
      else "";
  };
}
