{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.eclipse.stylix.enable = mkEnableOption "Enables Stylix";

  config = mkIf config.eclipse.stylix.enable {
    # https://stylix.danth.me/options/nixos.html
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
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

      fonts.sizes = mkForce {
        applications = 13;
        terminal = 13;
        desktop = 16;
        popups = 16;
      };

      opacity = {
        applications = 1.0;
        terminal = 1.0;
        desktop = 1.0;
        popups = 1.0;
      };

      polarity = "dark";

      # Manually configure plymouth in plymouth.nix
      targets.plymouth.enable = false;
      # Manually configure nixvim in home-manager module
      targets.nixvim.enable = false;
      # Disable fish since it conflicts with kitty theming
      targets.fish.enable = false;
      # It tries to use the deprecated "gnome" by default, so override it.
      targets.qt.platform = mkForce "qtct";
    };
    eclipse.hm = {
      # Manually configure kitty using builtin theming
      stylix.targets.kitty.enable = false;
      # Disable fish since it conflicts with kitty theming
      stylix.targets.fish.enable = false;
      # Overrides deprecated "gnome" platform theme name.
      qt.platformTheme.name = mkForce "adwaita";
    };
  };
}
