{
  pkgs,
  lib,
  config,
  ...
}: let
  patchedMpvPlex = pkgs.plex-desktop.overrideAttrs (previousAttrs: {
    postInstall = ''
      ${previousAttrs.postInstall or ""}

      # Remove built-in libmvp (save backup of it),
      # then symlink to updated libmpv
      ln --backup --force --symbolic --target-directory=${pkgs.plex-desktop}/lib ${pkgs.mpv}/lib/libmvp.so.2
    '';
  });
  #
  # patch = pkgs.runCommandNoCC "plex-desktop-mpv-patch" {} ''
  #   # Remove built-in libmvp (save backup of it),
  #   # then symlink to updated libmpv
  #   ln --backup --force --symbolic --target-directory=${pkgs.plex-desktop}/lib ${pkgs.mpv}/lib/libmvp.so.2
  # '';
in {
  options = {
    plex-desktop.enable = lib.mkEnableOption "Enables Plex Desktop";
  };

  config = lib.mkIf config.plex-desktop.enable {
    home.packages = [
      # pkgs.mpv # Dependency to be able to update libmpv.so.2
      patchedMpvPlex
      # patch
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
