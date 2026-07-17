#
# Simple image viewer application written with GTK4 and Rust.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.loupe.enable = mkEnableOption "Loupe";

  config = mkIf config.eclipse.loupe.enable {
    eclipse.hm = {
      pkgs,
      osConfig,
      ...
    }: {
      home.packages = [pkgs.loupe];

      programs.niri.settings.window-rules = mkIf osConfig.eclipse.niri.enable [
        #  Open as floating.
        {
          matches = [
            {app-id = "^org.gnome.Loupe$";}
          ];
          open-floating = true;
          min-width = 800;
          min-height = 800;
        }
      ];
    };
  };
}
