#
# Opens the current month's screenshot directory.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  open-screenshot-dir = pkgs.writers.writeBashBin "open-screenshot-dir.sh" ''
    set -eu

    YEAR=$(date +%Y)
    MONTH=$(date +%b)

    DIR=$HOME/Pictures/Screenshots/$YEAR/$MONTH

    mkdir -p $HOME/Pictures/Screenshots/$YEAR
    mkdir -p $DIR

    ${getExe pkgs.nemo} "$DIR"
  '';
in {
  options = {
    open-screenshot-dir.enable = mkEnableOption "Enables open-screenshot-dir";
  };

  config = mkIf config.open-screenshot-dir.enable {
    home.packages = [
      open-screenshot-dir
    ];
  };
}
