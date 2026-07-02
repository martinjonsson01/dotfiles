{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.util;
in {
  options.eclipse.util.enable = mkEnableOption "Enables the util profile.";

  config = mkIf cfg.enable {
    eclipse = {
      qalculate.enable = mkDefault true;

      hm = {pkgs, ...}: {
        home.packages = with pkgs; [
          fsearch # Like Void Tools Everything but on linux (i.e. file search)
          gparted # Disk partition editing/viewing tool
        ];
      };
    };
  };
}
