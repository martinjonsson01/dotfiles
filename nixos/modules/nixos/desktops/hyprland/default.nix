{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    # For the (required) NixOS Module: enables critical components needed to run Hyprland properly.
    programs.hyprland.enable = true;
    # Enable Universal Wayland Session Management (a way to start Hyprland on systemd distros)
    programs.hyprland.withUWSM = true;

    # services = {
    #   greetd = {
    #     enable = true;
    #     vt = 3;
    #     settings = {
    #       default_session = {
    #         user = "martin";
    #         command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
    #       };
    #     };
    #   };
    # };
  };
}
