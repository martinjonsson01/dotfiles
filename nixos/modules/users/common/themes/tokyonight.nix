#
# A clean, dark theme.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    tokyonight.enable = mkEnableOption "Enables Tokyonight";
  };

  config = mkIf config.tokyonight.enable (let
    tokyonight = pkgs.vimPlugins.tokyonight-nvim;
    variant = "night";
  in {
    # Delta
    programs.git = {
      delta.options.features = "tokyonight";
      includes = [{path = "~/.config/delta/tokyonight.gitconfig";}];
    };
    xdg.configFile."delta/tokyonight.gitconfig".source = "${tokyonight}/extras/delta/tokyonight_${variant}.gitconfig";

    # Kitty
    programs.kitty.themeFile = "tokyo_night_${variant}";
  });
}
