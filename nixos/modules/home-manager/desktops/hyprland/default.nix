{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.kitty.enable = true; # required for the default Hyprland config

    home.packages = with pkgs; [
      socat # Dependency for movewindow script
      jaq # Dependency for movewindow script
      xclip # Needed to fix clipboard in exec-once (see config/default.nix)
    ];

    # Script for moving windows across monitors.
    home.file."${config.xdg.configHome}/movewindow.sh" = {
      source = ./movewindow.sh;
      executable = true;
    };

    home.sessionVariables = {
      # Hint Electron apps to use Wayland.
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    wayland.windowManager.hyprland =
      {
        enable = true;
      }
      // (import ./config {inherit config lib pkgs osConfig;});
  };
}
