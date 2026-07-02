{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.util;
in {
  options.eclipse.util.enable = mkEnableOption "Enables the util profile.";

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
