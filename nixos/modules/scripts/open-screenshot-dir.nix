#
# Opens the current month's screenshot directory.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.open-screenshot-dir.enable = mkEnableOption "open-screenshot-dir";

  config = mkIf config.eclipse.open-screenshot-dir.enable {
    eclipse.hm = {pkgs, ...}: let
      open-screenshot-dir = pkgs.writers.writeBashBin "open-screenshot-dir.sh" ''
        set -eu

        YEAR=$(date +%Y)
        MONTH=$(date +%b)

        DIR=$HOME/Pictures/Screenshots/$YEAR/$MONTH

        mkdir -p $HOME/Pictures/Screenshots/$YEAR
        mkdir -p $DIR

        ${getExe pkgs.thunar} "$DIR"
      '';
    in {
      home.packages = [
        open-screenshot-dir
      ];
    };
  };
}
