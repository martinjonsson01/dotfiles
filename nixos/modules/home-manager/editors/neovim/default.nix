#
# Vim text editor fork focused on extensibility and agility.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    neovim.enable = mkEnableOption "Enables Neovim";
  };

  config = mkIf config.neovim.enable {
    programs.nixvim.enable = true;
  };
}
