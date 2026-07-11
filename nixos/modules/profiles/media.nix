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
      decibels.enable = mkDefault true;
      loupe.enable = mkDefault true;
      mpv.enable = mkDefault true;
      pinta.enable = mkDefault true;
      plex-desktop.enable = mkDefault true;
      swayimg.enable = mkDefault true;

      hm = {pkgs, ...}: {
        home.packages = with pkgs;
          [
            kdePackages.okular # KDE document viewer
            komikku # Comic reader
            mkvtoolnix # Mkv editing
            ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
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
