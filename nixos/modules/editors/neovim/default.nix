#
# Vim text editor fork focused on extensibility and agility.
#
{
  config,
  lib,
  ...
}:
with lib; let
  importTree = import ../../../lib/importTree.nix;
in {
  options.eclipse.neovim.enable = mkEnableOption "Neovim";

  config = mkIf config.eclipse.neovim.enable {
    eclipse.hm = {config, ...}: {
      programs.nixvim = {
        enable = true;
        # Use the host's nixpkgs instead of nixvim's own instance, so overlays
        # like pkgs.unstable are visible inside nixvim modules.
        nixpkgs.useGlobalPackages = true;
        # Nixvim is its own module system; expose the surrounding Home
        # Manager config to the modules in _config.
        _module.args.hmConfig = config;
        imports = importTree ./_config;
      };
    };
  };
}
