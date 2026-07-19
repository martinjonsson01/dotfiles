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

      # Launch Minecraft in the correct aspect ratio.
      programs.niri.settings.window-rules = [
        {
          matches = [
            {app-id = "^GT: New Horizons";}
            {app-id = "^Minecraft";}
          ];
          default-column-width = {
            proportion = 1.0 / 2.0;
          };
        }
      ];
    };
  };
}
