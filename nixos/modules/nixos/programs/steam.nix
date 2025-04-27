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

    # We need 32bit versions of all the OpenGL etc libraries for steam to run
    hardware.graphics.enable32Bit = true;
  };
}
