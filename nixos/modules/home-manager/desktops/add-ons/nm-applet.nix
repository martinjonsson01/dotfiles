#
# NetworkManager is a program for providing detection and configuration
# for systems to automatically connect to networks.
#
{
  config,
  lib,
  ...
}: {
  options = {
    nm-applet.enable = lib.mkEnableOption "Enables NetworkManager Gnome applet";
  };

  config = lib.mkIf config.nm-applet.enable {
    services.network-manager-applet.enable = true;
    xsession.preferStatusNotifierItems = true;
  };
}
