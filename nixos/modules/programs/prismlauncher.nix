#
# Launcher for Minecraft with modpack support.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.prismlauncher.enable = mkEnableOption "prismlauncher";

  config = mkIf config.eclipse.prismlauncher.enable {
    eclipse.hm = {
      programs.prismlauncher.enable = true;
    };
  };
}
