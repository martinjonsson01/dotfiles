#
# Vim text editor fork focused on extensibility and agility.
#
{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    neovim.enable = mkEnableOption "Enables Neovim";
  };

  config = mkIf config.neovim.enable {
    programs.nixvim =
      {
        enable = true;
      }
      // (import ./config);
  };
}
