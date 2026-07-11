#
# Wayland clipboard manager.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.cliphist.enable = mkEnableOption "Cliphist";

  config = mkIf config.eclipse.cliphist.enable {
    eclipse.hm = {pkgs, ...}: let
      cliphist-fuzzel-img =
        pkgs.writers.writeBashBin "cliphist-fuzzel-img" ./cliphist-fuzzel-img.sh;
    in {
      home.packages = with pkgs; [
        cliphist-fuzzel-img
        # Requirements for cliphist-fuzzel-img
        imagemagick
        fuzzel
      ];

      services.cliphist.enable = true;
    };
  };
}
