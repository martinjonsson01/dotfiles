#
# A helper for screenshots within hyprland
#
{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    grimblast.enable = lib.mkEnableOption "Enables grimblast";
  };

  config = lib.mkIf config.grimblast.enable {
    # grimblast is a screenshot grabber and swappy is a screenshot editor
    # This config provides comprehensive screenshot functionality for hyprland
    home = {
      packages = with pkgs; [
        grimblast
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
      };
    };
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          ", Print, exec, ${lib.getExe pkgs.grimblast} save screen - | ${lib.getExe pkgs.swappy} -f -"
          "SHIFT, Print, exec, ${lib.getExe pkgs.grimblast} save area - | ${lib.getExe pkgs.swappy} -f -"
          "CTRL ALT, Print, exec, ${lib.getExe pkgs.grimblast} save active - | ${lib.getExe pkgs.swappy} -f -"
          "CTRL, Print, exec, ${lib.getExe pkgs.grimblast} save output - | ${lib.getExe pkgs.swappy} -f -"
        ];
      };
    };
  };
}
