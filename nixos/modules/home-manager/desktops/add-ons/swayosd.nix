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
