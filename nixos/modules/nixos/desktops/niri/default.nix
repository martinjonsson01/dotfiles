{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    niri.enable = lib.mkEnableOption "Enables Niri";
  };

  config = lib.mkIf config.niri.enable {
    nixpkgs.overlays = [inputs.niri.overlays.niri];

    # Required for the home-manager-managed xdg portal definitions to get linked.
    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

    # To launch the Niri session.
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "${lib.getExe pkgs.tuigreet} --remember --cmd niri-session";
      };
    };
  };
}
