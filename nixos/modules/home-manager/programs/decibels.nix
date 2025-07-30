#
# An audio player that just plays audio files.
# It doesn't require an organized music library
# and won't overload you with tons of functionality.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    decibels.enable = mkEnableOption "Enables Decibels";
  };

  config = mkIf config.decibels.enable {
    home.packages = with pkgs; [decibels];

    programs.niri.settings.window-rules = mkIf config.niri.enable [
      #  Open as floating.
      {
        matches = [
          {app-id = "^decibels$";}
        ];
        open-floating = true;
      }
    ];
  };
}
