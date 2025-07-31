#
# Boot splash and boot logger.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    plymouth.enable = mkEnableOption "Enables Plymouth";
  };

  config = mkIf config.plymouth.enable {
    environment.systemPackages = [pkgs.plymouth];
    boot.plymouth = {
      enable = true;
      #theme = ?;
    };
  };
}
