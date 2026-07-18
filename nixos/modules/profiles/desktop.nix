{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.desktop;
in {
  options.eclipse.desktop.enable = mkEnableOption "the desktop profile";

  config = mkIf cfg.enable {
    eclipse = {
      activitywatch.enable = mkDefault true;
      audio.enable = mkDefault true;
      blueman-applet.enable = mkDefault true;
      copyq.enable = mkDefault true;
      decibels.enable = mkDefault true;
      easyeffects.enable = mkDefault true;
      fonts.enable = mkDefault true;
      fuzzel.enable = mkDefault true;
      gtk-theme.enable = mkDefault true;
      kitty.enable = mkDefault true;
      mic-default-mute.enable = mkDefault true;
      mpv.enable = mkDefault true;
      niri.enable = mkDefault true;
      nm-applet.enable = mkDefault true;
      nwg-bar.enable = mkDefault true;
      polkit-gnome.enable = mkDefault true;
      satty.enable = mkDefault true;
      stylix.enable = mkDefault true;
      sunsetr.enable = mkDefault true;
      swayidle.enable = mkDefault true;
      swayimg.enable = mkDefault true;
      swaync.enable = mkDefault true;
      thunar.enable = mkDefault true;
      tokyonight.enable = mkDefault true;
      waybar.enable = mkDefault true;

      # Scripts
      lock-script.enable = mkDefault true;
      niri-launch-kitty-workspace-cwd.enable = mkDefault true;
      niri-rename-workspace.enable = mkDefault true;
      open-screenshot-dir.enable = mkDefault true;
      screenrecord-region.enable = mkDefault true;
      screenshot-region.enable = mkDefault true;
      search-github-nix.enable = mkDefault true;
      search-google.enable = mkDefault true;

      hm = {pkgs, ...}: {
        services.swayosd.enable = true;

        home.packages = with pkgs; [
          kdePackages.okular # KDE document viewer
          nerd-fonts.jetbrains-mono # Font with icons
          nautilus # Necessary for file pickers, even if not used as primary file explorer.
          swappy # Necessary for screenshot script
          rofimoji # Emoji selector
        ];
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # To enable wayland support in e.g. Slack
  };
}
