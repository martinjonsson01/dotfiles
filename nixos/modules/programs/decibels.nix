#
# An audio player that just plays audio files.
# It doesn't require an organized music library
# and won't overload you with tons of functionality.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.decibels.enable = mkEnableOption "Enables Decibels";

  config = mkIf config.eclipse.decibels.enable {
    eclipse.hm = {
      pkgs,
      config,
      ...
    }: {
      home.packages = with pkgs; [decibels];

      programs.niri.settings.window-rules = mkIf config.niri.enable [
        #  Open as floating.
        {
          matches = [
            {app-id = "^org.gnome.Decibels$";}
          ];
          open-floating = true;
        }
      ];
    };
  };
}
