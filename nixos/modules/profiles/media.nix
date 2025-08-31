{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.Eclipse.media;
in {
  options.Eclipse.media.enable = mkEnableOption "Enables the media profile.";

  config = mkIf cfg.enable {
    home-manager.users.martin.home = {
      packages = with pkgs;
        [
        ]
        ++ (with pkgs.unstable; [
          ]);
    };
  };
}
