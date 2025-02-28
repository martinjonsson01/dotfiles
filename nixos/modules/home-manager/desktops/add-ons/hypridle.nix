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
    hypridle.enable = lib.mkEnableOption "Enables hypridle";
  };

  config = lib.mkIf config.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          ignore_dbus_inhibit = true;
          lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        };
        # listener = [
        #   {
        #     timeout = 300;
        #     on-timeout = "${lockScript.outPath} lock";
        #   }
        #   {
        #     timeout = 1800;
        #     on-timeout = "${lockScript.outPath} suspend";
        #   }
        # ];
      };
    };
  };
}
