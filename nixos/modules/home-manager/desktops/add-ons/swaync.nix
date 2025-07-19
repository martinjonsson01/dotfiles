#
# A simple notification daemon with a GTK gui for notifications and the control center.
#
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    swaync.enable = lib.mkEnableOption "Enables sway notification center";
  };

  config = lib.mkIf config.swaync.enable {
    home.packages = with pkgs; [
      swaynotificationcenter
    ];
  };
}
