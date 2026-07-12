#
# Lightweight Wayland-native image viewer.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.swayimg.enable = mkEnableOption "swayimg";

  config = mkIf config.eclipse.swayimg.enable {
    eclipse.hm = {
      pkgs,
      osConfig,
      ...
    }: let
      img-fit-window = pkgs.writers.writeBashBin "img-fit-window" ''
        set -eu
        read -r w h <<<"$(${getExe pkgs.imagemagick} identify -ping -format '%w %h' "$1"'[0]')"
        ${getExe pkgs.niri} msg action set-window-width "$w"
        ${getExe pkgs.niri} msg action set-window-height "$h"
        ${getExe pkgs.niri} msg action center-window
      '';
    in {
      home.packages = with pkgs; [swayimg img-fit-window];

      xdg.configFile."swayimg/config".text = ''
        [general]
        size = image

        [list]
        all = yes

        [info]
        show = no

        [info.viewer]
        top_left = name
        top_right = index
        bottom_left = scale
        bottom_right = none

        [keys.viewer]
        Left = prev_file
        Right = next_file
        e = exec ${getExe' pkgs.util-linux "setsid"} -f ${getExe pkgs.loupe} '%'
        Delete = exec ${getExe' pkgs.glib "gio"} trash '%'; skip_file
        MouseRight = zoom real; exec ${img-fit-window}/bin/img-fit-window '%'
      '';

      programs.niri.settings.window-rules = mkIf osConfig.eclipse.niri.enable [
        # Floating so size=image gives a window matching the image exactly.
        {
          matches = [
            {app-id = "^swayimg$";}
          ];
          open-floating = true;
        }
      ];
    };
  };
}
