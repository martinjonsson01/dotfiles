#
# A helper for screenshots within Gnome
#
{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    gnome-screenshot.enable = lib.mkEnableOption "Enables gnome-screenshot";
  };

  config = lib.mkIf config.gnome-screenshot.enable {
    home.packages = with pkgs; [
      gnome-screenshot
    ];

    # Script for screenshots that get saved to dated directory.
    home.file."${config.xdg.configHome}/screenshot.sh" = {
      source = ./screenshot.sh;
      executable = true;
    };

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          ", Print, exec, ${config.xdg.configHome}/screenshot.sh screen"
          "CTRL, Print, exec, ${config.xdg.configHome}/screenshot.sh area"
          "CTRL ALT, Print, exec,  ${config.xdg.configHome}/screenshot.sh active"
          "SHIFT, Print, exec,  ${config.xdg.configHome}/screenshot.sh output"
        ];
      };
    };
  };
}
