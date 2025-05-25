{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    custom-style.enable = lib.mkEnableOption "Enables Stylix";
  };

  config = lib.mkIf config.custom-style.enable {
    # https://stylix.danth.me/options/nixos.html
    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      image = /run/current-system/sw/share/backgrounds/gnome/blobs-l.svg;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 10;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
      };

      fonts.sizes = {
        applications = 13;
        terminal = 13;
        desktop = 13;
        popups = 16;
      };

      opacity = {
        applications = 1.0;
        terminal = 1.0;
        desktop = 1.0;
        popups = 1.0;
      };

      polarity = "dark";
    };
  };
}
