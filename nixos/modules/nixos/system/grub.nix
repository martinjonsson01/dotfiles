#
# GNU GRUB, the Grand Unified Boot Loader.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  catppuccin = pkgs.catppuccin-grub.override {
    flavor = "mocha";
  };

  monitors = config.myHardware.monitors;
  mainMonitor =
    lists.findSingle (monitor: monitor.primary)
    (lists.head monitors)
    (lists.head monitors)
    monitors;
in {
  config.boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      theme = mkForce catppuccin;
      splashImage = mkForce "${catppuccin}/background.png";
      extraConfig = ''
        GRUB_GFXMODE="${toString mainMonitor.width}x${toString mainMonitor.height}"
      '';
    };
    efi.canTouchEfiVariables = true;
  };
}
