#
# Pinta is a free, open-source program for drawing and image editing.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.pinta.enable = mkEnableOption "Pinta";

  config = mkIf config.eclipse.pinta.enable {
    eclipse.hm = {pkgs, ...}: {
      home.packages = with pkgs; [
        pinta
      ];
    };
  };
}
