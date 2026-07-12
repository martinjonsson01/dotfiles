#
# General-purpose media player, fork of MPlayer and mplayer2.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.mpv.enable = mkEnableOption "MPV";

  config = mkIf config.eclipse.mpv.enable {
    eclipse.hm = {osConfig, ...}: {
      programs.mpv = {
        enable = true;
        config = {
          volume = 60;
          # Normalize loudness to a constant level (EBU R128) regardless of source.
          af = "loudnorm=I=-18:TP=-1.5:LRA=11";
        };
      };

      programs.niri.settings.window-rules = mkIf osConfig.eclipse.niri.enable [
        #  Open as floating.
        {
          matches = [
            {app-id = "^mpv$";}
          ];
          open-floating = true;
          min-width = 800;
          min-height = 800;
        }
      ];
    };
  };
}
