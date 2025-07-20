#
# Adjust the color temperature of your screen according to
# your surroundings. This may help your eyes hurt less if you are
# working in front of the screen at night.
#
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    gammastep.enable = lib.mkEnableOption "Enables gammastep";
  };

  config = lib.mkIf config.gammastep.enable {
    services.gammastep = {
      enable = true;
      temperature.night = 3000;
      dawnTime = "09:40-09:41";
      duskTime = "09:38-09:39";
    };
  };
}
