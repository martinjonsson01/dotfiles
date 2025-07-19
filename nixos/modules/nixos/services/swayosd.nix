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
    environment.systemPackages = with pkgs; [swayosd];
    systemd.packages = with pkgs; [swayosd];
    systemd.services."swayosd-libinput-backend" = {
      wantedBy = ["graphical.target"];
    };
  };
}
