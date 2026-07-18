{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.media;
in {
  options.eclipse.media.enable = mkEnableOption "the media profile";

  config = mkIf cfg.enable {
    eclipse = {
      pinta.enable = mkDefault true;
      plex-desktop.enable = mkDefault true;

      hm = {pkgs, ...}: {
        home.packages = with pkgs;
          [
            komikku # Comic reader
            mkvtoolnix # Mkv editing
            yt-dlp # To download youtube videos
            video-trimmer # For trimming video files
            songrec # Shazam song recognition
          ]
          ++ (with pkgs.unstable; [
            (plexamp.overrideAttrs (old: {
              nativeBuildInputs = (old.nativeBuildInputs or []) ++ [makeWrapper];
              buildCommand = ''
                ${old.buildCommand}
                source "${makeWrapper}/nix-support/setup-hook"
                wrapProgram "$out/bin/plexamp" --add-flags "--disable-gpu"
              '';
            }))
          ]);
      };
    };
  };
}
