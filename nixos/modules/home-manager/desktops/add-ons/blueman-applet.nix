#
# GTK-based Bluetooth Manager
#
{
  config,
  lib,
  ...
}: {
  options = {
    blueman-applet.enable = lib.mkEnableOption "Enables Blueman Applet";
  };

  config = lib.mkIf config.blueman-applet.enable {
    services.blueman-applet.enable = true;
  };
}
