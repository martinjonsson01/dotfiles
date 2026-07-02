#
# zoom.us video conferencing application.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.zoom.enable = mkEnableOption "Enables Zoom";

  config = mkIf config.eclipse.zoom.enable {
    eclipse.hm = {pkgs, ...}: {
      home.packages = [
        pkgs.unstable.zoom-us
        # For screensharing
        pkgs.xdg-desktop-portal
      ];

      xdg.desktopEntries."zoom-wayland" = {
        name = "zoom-wayland";
        genericName = "Proprietary meeting app, lauching with wayland flags";
        exec = "zoom-us --enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };
  };
}
