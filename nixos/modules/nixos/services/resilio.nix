{
  pkgs,
  config,
  ...
}: {
  services.resilio = {
    enable = true;

    directoryRoot = "/big-chungus/Drive";

    deviceName = config.networking.hostName;

    enableWebUI = true;
    httpListenPort = 10000;
    httpListenAddr = "0.0.0.0";
  };
}
