#
# Fonts for NixOS
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.eclipse.fonts.enable = mkEnableOption "Enables fonts";

  config = mkIf config.eclipse.fonts.enable {
    fonts.packages = with pkgs; [
      lato
      # "no tofu" fonts for multilingual support
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };
}
