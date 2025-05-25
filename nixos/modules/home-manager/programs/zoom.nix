#
# zoom.us video conferencing application.
#
{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}: {
  options = {
    zoom.enable = lib.mkEnableOption "Enables Zoom";
  };

  config = lib.mkIf config.zoom.enable {
    home.packages = [
      pkgs-unstable.zoom-us
      # For screensharing
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gnome
    ];

    xdg.desktopEntries."zoom-wayland" = {
      name = "zoom-wayland";
      genericName = "Proprietary meeting app, lauching with wayland flags";
      exec = "zoom-us --enable-features=UseOzonePlatform --ozone-platform=wayland";
    };
  };
}
