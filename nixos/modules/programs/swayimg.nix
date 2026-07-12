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
      # Open at 150% zoom: window sized to 1.5x the image, image fit to window.
      swayimg-zoomed = pkgs.writers.writeBashBin "swayimg-zoomed" ''
        set -eu
        read -r w h <<<"$(${getExe pkgs.imagemagick} identify -ping -format '%w %h' "$1"'[0]')"
        exec ${getExe pkgs.swayimg} --size=$((w * 3 / 2)),$((h * 3 / 2)) --scale=fit "$@"
      '';
    in {
      home.packages = with pkgs; [swayimg img-fit-window swayimg-zoomed];

      # Shadows the package's desktop entry so file managers open the zoomed wrapper.
      xdg.desktopEntries.swayimg = {
        name = "Swayimg";
        exec = "${swayimg-zoomed}/bin/swayimg-zoomed %F";
        icon = "swayimg";
        terminal = false;
        categories = ["Graphics" "Viewer"];
        mimeType = ["image/*"];
      };

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
