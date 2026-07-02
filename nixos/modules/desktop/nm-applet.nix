#
# NetworkManager is a program for providing detection and configuration
# for systems to automatically connect to networks.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.nm-applet.enable = mkEnableOption "Enables NetworkManager Gnome applet";

  config = mkIf config.eclipse.nm-applet.enable {
    eclipse.hm = {
      services.network-manager-applet.enable = true;
      xsession.preferStatusNotifierItems = true;
    };
  };
}
