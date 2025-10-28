#
# Fonts for NixOS
#
{
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    lato
  ];
}
