#
# A clean, dark theme.
#
{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    tokyonight.enable = mkEnableOption "Enables Tokyonight";
  };

  config = mkIf config.tokyonight.enable (let
    variant = "night";
  in {
    # Kitty
    programs.kitty.themeFile = "tokyo_night_${variant}";
  });
}
