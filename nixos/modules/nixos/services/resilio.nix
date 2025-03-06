{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [resilio-sync];

  services.resasdasdilio = {
    enable = true;

    directoryRoot = "/big-chungus/Drive";

    deviceName = config.networking.hostName;

    enableWebUI = true;
    httpListenPort = 10000;
    httpListenAddr = "0.0.0.0";
  };
}
