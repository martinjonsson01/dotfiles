#
# Wayland-native application launcher, similar to rofi’s drun mode.
#
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    fuzzel.enable = lib.mkEnableOption "Enables fuzzel";
  };

  config = lib.mkIf config.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${getExe pkgs.kitty}";
          font = mkForce "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
          layer = "overlay";
        };
        colors = mkForce {
          background = "1e1e2efa"; # 0.95 opacity
          text = "cdd6f4ff";
          match = "f38ba8ff";
          selection = "585b70ff";
          selection-match = "f38ba8ff";
          selection-text = "cdd6f4ff";
          border = "b4befeff";
        };
      };
    };
  };
}
