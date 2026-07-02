#
# Scrollable-tiling Wayland compositor.
#
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.eclipse.niri.enable = mkEnableOption "Enables Niri";

  config = mkIf config.eclipse.niri.enable {
    nixpkgs.overlays = [inputs.niri.overlays.niri];

    # Required for the home-manager-managed xdg portal definitions to get linked.
    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

    # To launch the Niri session.
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "${getExe pkgs.tuigreet} --remember --cmd niri-session";
      };
    };

    # niri-flake only runs the keyring as a user service; the system-level
    # module is what wires PAM auto-unlock for greetd and D-Bus activation of
    # the gcr unlock prompter.
    services.gnome.gnome-keyring.enable = true;
    services.gnome.gcr-ssh-agent.enable = true;

    programs.ssh.askPassword = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";

    eclipse.default-applications.enable = mkDefault true;

    eclipse.hm = {
      config,
      osConfig,
      lib,
      pkgs,
      ...
    }: {
      # Nix packages configure Chrome and Electron apps to run in native Wayland
      # mode if this environment variable is set.
      home.sessionVariables.NIXOS_OZONE_WL = "1";
      home.packages = with pkgs; [
        kitty # Terminal emulator
        fuzzel # Application launcher
        swaylock # Lock screen
        xwayland-satellite # X11 compatibility
      ];

      targets.genericLinux.enable = true;

      # Niri's portals.conf routes the Access and Notification interfaces to
      # the GTK portal; niri-flake only ships the GNOME one.
      xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

      programs.niri =
        {
          enable = true;
          package = pkgs.niri-unstable;
        }
        // (import ./_config {
          inherit
            config
            lib
            pkgs
            osConfig
            ;
        });
    };
  };
}
