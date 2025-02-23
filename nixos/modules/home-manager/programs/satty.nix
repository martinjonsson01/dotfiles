#
# Satty is a screenshot annotation tool inspired by Swappy and Flameshot.
#
{
  pkgs,
  config,
  lib,
  ...
}: let
  settings = {
    general = {
      fullscreen = false;
      early-exit = true;
      initial-tool = "brush";
      copy-command = "wl-copy";
      annotation-size-factor = 1;
      save-after-copy = false;
      default-hide-toolbars = false;
      primary-highlighter = "block";
    };

    font = {
      family = config.stylix.fonts.sansSerif.name;
      style = "Regular";
    };
  };
in {
  options = {
    satty.enable = lib.mkEnableOption "Enables Satty";
  };

  config = lib.mkIf config.satty.enable {
    home.packages = [pkgs.satty];
    xdg.configFile."satty/config.toml".source = pkgs.writers.writeTOML "satty-config.toml" settings;
  };
}
