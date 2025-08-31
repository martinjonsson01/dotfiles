#
# Thunar is a GTK file manager originally made for Xfce.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    thunar.enable = mkEnableOption "Enables Thunar";
  };

  config = mkIf config.thunar.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.xdg-desktop-portal-kde # For file pickers
    ];

    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin # Provides file context menus for archives.
          thunar-volman # Provides automatic management of removable drives and media.
        ];
      };
      # If xfce is not used as desktop and therefore xfconf is not enabled, preference changes are discarded.
      xfconf.enable = true;
    };
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images

    home-manager.users.martin.programs.niri.settings.window-rules = mkIf config.niri.enable [
      {
        matches = [
          {
            app-id = "^thunar$";
            title = "^Rename \".*\"$";
          }
        ];
        open-floating = true;
      }
    ];

    # Override which file manager is used by dbus.
    home-manager.users.martin.xdg.dataFile."dbus-1/services/org.freedesktop.FileManager1.service".text = ''
      [D-BUS Service]
      Name=org.freedesktop.FileManager1
      Exec=${getExe pkgs.xfce.thunar}
    '';
  };
}
