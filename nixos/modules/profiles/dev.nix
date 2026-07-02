{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.dev;
in {
  options.eclipse.dev.enable = mkEnableOption "Enables the dev profile.";

  config = mkIf cfg.enable {
    ccache.enable = true;

    home-manager.users.martin = {
    };
  };
}
