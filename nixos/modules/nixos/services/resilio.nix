{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    resilio.enable = lib.mkEnableOption "Enables Resilio sync";
  };

  config = lib.mkIf config.resilio.enable {
    services.resilio = {
      enable = true;

      directoryRoot = "/big-chungus/Drive";

      deviceName = config.networking.hostName;

      enableWebUI = true;
      httpListenPort = 10000;
      httpListenAddr = "0.0.0.0";
    };
  };
}
