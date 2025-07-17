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

    # To launch the Niri session.
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --cmd niri-session";
      };
    };
  };
}
