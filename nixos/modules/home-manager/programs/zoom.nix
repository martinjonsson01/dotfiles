#
# zoom.us video conferencing application.
#
{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    zoom.enable = lib.mkEnableOption "Enables Zoom";
  };

  config = lib.mkIf config.zoom.enable {
    home.packages = [
      pkgs.zoom
    ];
  };
}
