#
# Open Source gaming platform for GNU/Linux.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    lutris.enable = mkEnableOption "Enables lutris";
  };

  config = mkIf config.lutris.enable {
    programs.lutris = {
      enable = true;
      protonPackages = [pkgs.proton-ge-bin];
      extraPackages = with pkgs; [
        mangohud
        winetricks
        gamescope
        gamemode
        umu-launcher
      ];
    };
  };
}
