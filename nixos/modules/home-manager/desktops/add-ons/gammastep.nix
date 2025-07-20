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
}: let
  startTime = "19:00:00";
  endTime = "05:00:00";
  temperature = 3000;
in
  with lib; {
    options = {
      gammastep.enable = lib.mkEnableOption "Enables gammastep";
    };

    config = lib.mkIf config.gammastep.enable {
      services.gammastep = {
        enable = true;
        temperature.night = 3000;
        dawnTime = "05:00";
        duskTime = "19:00";
      };
    };
  }
