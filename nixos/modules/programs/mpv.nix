#
# General-purpose media player, fork of MPlayer and mplayer2.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.mpv.enable = mkEnableOption "Enables MPV";

  config = mkIf config.eclipse.mpv.enable {
    eclipse.hm = {
      pkgs,
      config,
      ...
    }: {
      home.packages = with pkgs; [mpv];

      programs.niri.settings.window-rules = mkIf config.niri.enable [
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
