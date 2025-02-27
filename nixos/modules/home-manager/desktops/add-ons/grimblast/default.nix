#
# A helper for screenshots within hyprland
#
{
  lib,
  pkgs,
  config,
  ...
}: let
  screenshotDir = "${config.home.homeDirectory}/Pictures/Screenshots/$(date +%Y)/$(date +%b)";
in {
  options = {
    grimblast.enable = lib.mkEnableOption "Enables grimblast";
  };

  config = lib.mkIf config.grimblast.enable {
    # grimblast is a screenshot grabber and swappy is a screenshot editor
    # This config provides comprehensive screenshot functionality for hyprland
    home = {
      packages = with pkgs; [
        grimblast
        swappy
      ];

      file = {
        "${config.xdg.configHome}/swappy/config".text = ''
          [Default]
          save_dir=${config.home.homeDirectory}/Pictures/Screenshots
          save_filename_format=screenshot-%Y%m%d-%H%M%S.png
          text_size=50
          text_font=Work Sans Bold
          early_exit=true
        '';

        # Script for screenshots that get saved to file and clipboard.
        "${config.xdg.configHome}/screenshot.sh" = {
          source = ./screenshot.sh;
          executable = true;
        };
      };
    };
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          ", Print, exec, ${config.xdg.configHome}/screenshot.sh screen"
          "SHIFT, Print, exec, ${config.xdg.configHome}/screenshot.sh area"
          "CTRL ALT, Print, exec,  ${config.xdg.configHome}/screenshot.sh active"
          "CTRL, Print, exec,  ${config.xdg.configHome}/screenshot.sh output"
        ];
      };
    };
  };
}
