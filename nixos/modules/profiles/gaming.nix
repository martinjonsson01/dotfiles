{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.gaming;
in {
  options.eclipse.gaming.enable = mkEnableOption "the gaming profile";

  config = mkIf cfg.enable {
    eclipse = {
      lutris.enable = mkDefault true;
      steam.enable = mkDefault true;
    };
  };
}
