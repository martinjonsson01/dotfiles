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
    programs.nixvim =
      {
        enable = true;
        # Use the host's nixpkgs instead of nixvim's own instance, so overlays
        # like pkgs.unstable are visible inside nixvim modules.
        nixpkgs.useGlobalPackages = true;
      }
      // (import ./config {inherit pkgs lib config;});
  };
}
