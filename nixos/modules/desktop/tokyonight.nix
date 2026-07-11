#
# A clean, dark theme.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.tokyonight.enable = mkEnableOption "Tokyonight";

  config = mkIf config.eclipse.tokyonight.enable {
    eclipse.hm = let
      variant = "night";
    in {
      # Kitty
      programs.kitty.themeFile = "tokyo_night_${variant}";
    };
  };
}
