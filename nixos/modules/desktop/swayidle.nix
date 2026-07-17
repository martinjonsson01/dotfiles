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
  lib,
  ...
}:
with lib; {
  options.eclipse.swayidle.enable = mkEnableOption "swayidle";

  config = mkIf config.eclipse.swayidle.enable {
    eclipse.hm = {
      pkgs,
      osConfig,
      ...
    }: {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            # Execute timeout command if there is no activity for seconds.
            timeout = 60 * 30;
            command =
              if osConfig.eclipse.niri.enable
              then "${getExe pkgs.niri} msg action power-off-monitors"
              else "";
          }
        ];
        systemdTargets = [];
      };
      systemd.user.services.swayidle.Unit.WantedBy =
        if osConfig.eclipse.niri.enable
        then "niri.service"
        else "";
    };
  };
}
