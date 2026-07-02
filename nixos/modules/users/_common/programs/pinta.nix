#
# Pinta is a free, open-source program for drawing and image editing.
#
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    pinta.enable = lib.mkEnableOption "Enables Pinta";
  };

  config = lib.mkIf config.pinta.enable {
    home.packages = with pkgs; [
      pinta
    ];
  };
}
