{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.plex-desktop.enable = mkEnableOption "Enables Plex Desktop";

  config = mkIf config.eclipse.plex-desktop.enable {
    eclipse.hm = {pkgs, ...}: {
      home.packages = [
        pkgs.unstable.plex-desktop
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
      # Manual MPV controls.
      xdg.dataFile."plex/scripts/mpv-keybinds.lua".source = ./mpv-keybinds.lua;
    };
  };
}
