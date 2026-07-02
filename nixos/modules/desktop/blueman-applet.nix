#
# GTK-based Bluetooth Manager
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.blueman-applet.enable = mkEnableOption "Enables Blueman Applet";

  config = mkIf config.eclipse.blueman-applet.enable {
    eclipse.hm = {
      services.blueman-applet.enable = true;
      dconf.settings."org/blueman/general" = {
        # Disable excessive notifications.
        plugin-list = ["!ConnectionNotifier"];
      };
    };
  };
}
