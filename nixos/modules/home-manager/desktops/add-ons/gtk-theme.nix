#
# Styling for GTK
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    gtk-theme.enable = lib.mkEnableOption "Enables GTK theme";
  };

  config = lib.mkIf config.gtk-theme.enable {
    home.pointerCursor = {
      package = config.stylix.cursor.package;
      name = config.stylix.cursor.name;
      size = config.stylix.cursor.size;
      gtk.enable = true;
      x11.enable = true;
    };
    gtk = {
      enable = true;
      font = {
        name = config.stylix.fonts.sansSerif.name;
        size = config.stylix.fonts.sizes.desktop;
      };
      theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
      iconTheme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
    };
  };
}
