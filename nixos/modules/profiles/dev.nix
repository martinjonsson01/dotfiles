{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.Eclipse.dev;
in {
  options.Eclipse.dev.enable = mkEnableOption "Enables the dev profile.";

  config = mkIf cfg.enable {
    home-manager.users.martin = {
    };
  };
}
