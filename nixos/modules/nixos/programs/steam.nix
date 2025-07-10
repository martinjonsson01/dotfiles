#
# Gaming platform.
#
{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    steam.enable = lib.mkEnableOption "Enables Steam";
  };

  config = lib.mkIf config.steam.enable {
    environment.systemPackages = with pkgs; [
      steam
      # The FHS-compatible chroot used for Steam can also be used to run other Linux games that expect a FHS environment.
      steam-run
    ];

    # SteamOS session compositing window manager, used to fix some incompatible games.
    programs.gamescope.enable = true;

    # We need 32bit versions of all the OpenGL etc libraries for steam to run
    hardware.graphics.enable32Bit = true;

    # Configure Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            libkrb5
            keyutils
          ];
      };
    };
  };
}
