{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.Eclipse.social;
in {
  options.Eclipse.social.enable = mkEnableOption "Enables the social profile.";

  config = mkIf cfg.enable {
    home-manager.users.martin = {
      home.packages = with pkgs; [
      ];
    };
  };
}
