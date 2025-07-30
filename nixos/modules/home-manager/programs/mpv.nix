#
# General-purpose media player, fork of MPlayer and mplayer2.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    mpv.enable = mkEnableOption "Enables MPV";
  };

  config = mkIf config.mpv.enable {
    home.packages = with pkgs; [mpv];

    programs.niri.settings.window-rules = mkIf config.niri.enable [
      #  Open as floating.
      {
        matches = [
          {app-id = "^mpv$";}
        ];
        open-floating = true;
      }
    ];
  };
}
