#
# Fonts for NixOS
#
{pkgs, ...}: {
  fonts.packages = with pkgs; [
    lato
    # "no tofu" fonts for multilingual support
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
