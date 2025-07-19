#
# A OSD window for common actions like volume and capslock..
#
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    swayosd.enable = lib.mkEnableOption "Enables SwayOSD";
  };

  config = lib.mkIf config.swayosd.enable {
    home.packages = with pkgs; [
      swayosd
      # Need to update dbus policy to allow the swayosd bus name.
      (pkgs.writeTextFile {
        name = "swayosd.conf";
        text = ''
          <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
           "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
          <busconfig>
            <policy user="root">
              <allow own="org.erikreider.swayosd"/>
            </policy>
          </busconfig>
        '';
        destination = "/etc/dbus-1/system.d/swayosd.conf";
      })
    ];

    systemd.user.services.swayosd = {
      Unit = {
        Description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc...";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = getExe' pkgs.swayosd "swayosd-libinput-backend";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
