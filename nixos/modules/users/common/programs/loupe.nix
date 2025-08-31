#
# Simple image viewer application written with GTK4 and Rust.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    loupe.enable = mkEnableOption "Enables Loupe";
  };

  config = mkIf config.loupe.enable {
    home.packages = with pkgs; [loupe];

    programs.niri.settings.window-rules = mkIf config.niri.enable [
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
}
