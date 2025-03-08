{
  pkgs,
  lib,
  config,
  ...
}: let
  # plexWithUpdatedMpvLib =
  # pkgs.runCommand "plex-desktop" {
  #   buildInputs = [pkgs.makeWrapper];
  # } ''
  #   mkdir $out
  #
  #   # Link every top-level folder from pkgs.hello to our new target
  #   ln -s ${pkgs.plex-desktop}/* $out
  #
  #   # Except the lib folder
  #   rm $out/lib
  #   mkdir $out/lib
  #
  #   # Except the bin folder
  #   rm $out/bin
  #   mkdir $out/bin
  #
  #
  #   # We create the lib folder ourselves and link every library in it
  #   ln -s ${pkgs.plex-desktop}/lib/* $out/lib
  #
  #   # Except the mpv library
  #   rm $out/lib/libmvp.so.2
  #
  #   # We take the latest mpv binary from the mpv package
  #   ln -s ${pkgs.mpv}/lib/libmpv.so.2 $out/lib
  #
  #
  #   # We create the bin folder ourselves and link every binary in it
  #   ln -s ${pkgs.plex-desktop}/bin/* $out/bin
  #
  #   # Except the plex binary
  #   rm $out/bin/plex-desktop
  #
  #   # Because we create this ourself, by creating a wrapper
  #   makeWrapper ${pkgs.plex-desktop}/bin/plex-desktop $out/bin/plex-desktop
  # '';
in {
  options = {
    plex-desktop.enable = lib.mkEnableOption "Enables Plex Desktop";
  };

  config = lib.mkIf config.plex-desktop.enable {
    home.packages = [
      # plexWithUpdatedMpvLib
      pkgs.plex-desktop
    ];

    xdg.dataFile."plex/mpv.conf".text = ''
      vf=help

      # For HDR content
      vo=gpu-next
      target-colorspace-hint

      gpu-api=d3d11
      gpu-context=wayland

      # Required for the dynamic-crop script
      hwdec=no
    '';

    # Script that auto-crops black bars.
    xdg.dataFile."plex/scripts/dynamic-crop.lua".source = ./dynamic-crop.lua;
  };
}
