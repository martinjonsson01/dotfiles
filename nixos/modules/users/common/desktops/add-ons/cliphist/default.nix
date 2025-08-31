#
# Wayland clipboard manager.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cliphist-fuzzel-img =
    pkgs.writers.writeBashBin "cliphist-fuzzel-img" ./cliphist-fuzzel-img.sh;
in {
  options = {
    cliphist.enable = mkEnableOption "Enables Cliphist";
  };

  config = mkIf config.cliphist.enable {
    home.packages = with pkgs; [
      cliphist-fuzzel-img
      # Requirements for cliphist-fuzzel-img
      imagemagick
      fuzzel
    ];

    services.cliphist.enable = true;
  };
}
