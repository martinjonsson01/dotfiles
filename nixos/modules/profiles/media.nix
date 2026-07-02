{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.media;
in {
  options.eclipse.media.enable = mkEnableOption "Enables the media profile.";

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
