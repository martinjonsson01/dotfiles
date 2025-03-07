{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    plex-desktop.enable = lib.mkEnableOption "Enables Plex Desktop";
  };

  config = lib.mkIf config.plex-desktop.enable {
    home.packages = with pkgs; [
      plex-desktop
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
