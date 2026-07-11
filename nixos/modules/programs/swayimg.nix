#
# Lightweight Wayland-native image viewer.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.swayimg.enable = mkEnableOption "Enables swayimg";

  config = mkIf config.eclipse.swayimg.enable {
    eclipse.hm = {
      pkgs,
      osConfig,
      ...
    }: let
      magick = getExe pkgs.imagemagick;
      fileCmd = "${pkgs.file}/bin/file";
      # Gifs are coalesced so the transform applies to whole frames, not
      # inter-frame diffs.
      img-rotate = pkgs.writers.writeBashBin "img-rotate" ''
        set -eu
        file="$1"
        degrees="$2"
        case "$(${fileCmd} -b --mime-type "$file")" in
          image/gif) ${magick} "$file" -coalesce -rotate "$degrees" -layers optimize "$file" ;;
          *) ${magick} "$file" -auto-orient -rotate "$degrees" "$file" ;;
        esac
      '';
      img-resize = pkgs.writers.writeBashBin "img-resize" ''
        set -eu
        file="$1"
        choice=$(printf '%s\n' '75%' '50%' '33%' '25%' '10%' 'width 1920' 'width 1280' 'width 800' \
          | ${getExe pkgs.fuzzel} --dmenu --prompt "Resize to: ") || exit 0
        [ -n "$choice" ] || exit 0
        case "$choice" in
          width\ *) geometry="''${choice#width }" ;;
          *) geometry="$choice" ;;
        esac
        case "$(${fileCmd} -b --mime-type "$file")" in
          image/gif) ${magick} "$file" -coalesce -resize "$geometry" -layers optimize "$file" ;;
          *) ${magick} "$file" -resize "$geometry" "$file" ;;
        esac
      '';
    in {
      home.packages = with pkgs; [swayimg gifsicle img-rotate img-resize];

      xdg.configFile."swayimg/config".text = ''
        [general]
        size = image

        [list]
        all = yes

        [keys.viewer]
        Left = prev_file
        Right = next_file
        Up = zoom +10
        Down = zoom -10
        Shift+Up = step_up 10
        Shift+Down = step_down 10
        ScrollUp = zoom +10 mouse
        ScrollDown = zoom -10 mouse
        e = exec ${getExe' pkgs.util-linux "setsid"} -f ${getExe pkgs.loupe} '%'
        Ctrl+r = exec ${img-rotate}/bin/img-rotate '%' 90; reload
        Ctrl+Shift+r = exec ${img-rotate}/bin/img-rotate '%' 270; reload
        Ctrl+s = exec ${img-resize}/bin/img-resize '%'; reload
        Delete = exec ${getExe' pkgs.glib "gio"} trash '%'; skip_file
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
