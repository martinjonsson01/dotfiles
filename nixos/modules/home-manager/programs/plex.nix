{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    plex-desktop.enable = lib.mkEnableOption "Enables Plex Desktop";
  };

  config = lib.mkIf config.plex-desktop.enable {
    home.packages = with pkgs; [
      plex-desktop
    ];

    xdg.dataFile."plex/mpv.conf".text = ''
      vf=vlip
    '';
  };
}
