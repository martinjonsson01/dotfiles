#
# Styling for GTK
#
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    gtk-theme.enable = mkEnableOption "Enables GTK theme";
  };

  config = mkIf config.gtk-theme.enable {
    home.packages = with pkgs; [
      gtk-engine-murrine
    ];

    home.pointerCursor = mkForce {
      package = config.stylix.cursor.package;
      name = config.stylix.cursor.name;
      size = config.stylix.cursor.size;
      gtk.enable = true;
      x11.enable = true;
    };
    gtk = {
      enable = true;
      font = mkForce {
        name = config.stylix.fonts.sansSerif.name;
        size = config.stylix.fonts.sizes.applications;
      };
      theme = mkForce {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
      iconTheme = mkForce {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme.override {iconVariants = ["Dark"];};
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-button-images = true;
        gtk-menu-images = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-button-images = true;
        gtk-menu-images = true;
      };
    };
  };
}
