{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.dev;
in {
  options.eclipse.dev.enable = mkEnableOption "Enables the dev profile.";

  config = mkIf cfg.enable {
    eclipse = {
      ccache.enable = mkDefault true;
      gdb-dashboard.enable = mkDefault true;
      jetbrains.enable = mkDefault true;
      podman.enable = mkDefault true;
      vscode.enable = mkDefault true;

      hm = {pkgs, ...}: {
        home.packages = with pkgs; [
          nil # LSP for Nix
          sops # Secrets management
          pre-commit # Hooks that run before committing
          gcc # GNU Compiler Collection
          python310 # Scripting
          (pkgs.linkFarm "runghc" [
            {
              name = "bin/runghc";
              path = "${pkgs.ihaskell}/bin/runghc";
            }
          ]) # Run Haskell scripts
        ];
      };
    };
  };
}
