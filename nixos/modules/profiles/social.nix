{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.social;
in {
  options.eclipse.social.enable = mkEnableOption "Enables the social profile.";

  config = mkIf cfg.enable {
    eclipse = {
      zoom.enable = mkDefault true;

      hm = {pkgs, ...}: {
        home.packages = with pkgs; [
          discord
          slack
          hexchat # IRC Client
        ];
      };
    };
  };
}
