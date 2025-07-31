#
# GNU GRUB, the Grand Unified Boot Loader.
#
{
  pkgs,
  lib,
  myHardware,
  ...
}:
with lib; let
  catppuccin = pkgs.catppuccin-grub.override {
    flavor = "mocha";
  };

  monitors = myHardware.monitors;
  mainMonitor =
    lists.findSingle (monitor: monitor.primary)
    (lists.head monitors)
    (lists.head monitors)
    monitors;
in {
  config.boot.loader.grub = {
    theme = catppuccin;
    splashImage = "${catppuccin}/background.png";
    extraConfig = ''
      GRUB_GFXMODE="${toString mainMonitor.width}x${toString mainMonitor.height}"
    '';
  };
}
