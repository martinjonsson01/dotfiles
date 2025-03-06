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
    environment.systemPackages = with pkgs; [resilio-sync];

    sops.secrets."resilio-secret" = {
      sopsFile = ./../../../secrets/resilio-secret.txt;
      format = "binary";
    };

    services.resilio = {
      enable = true;

      deviceName = config.networking.hostName;

      enableWebUI = false;
      sharedFolders = [
        {
          directory = "/big-chungus/Drive";
          secretFile = config.sops.secrets."resilio-secret".path;
          knownHosts = [
            "192.168.0.162"
          ];
          searchLAN = true;
          useDHT = false;
          useRelayServer = true;
          useSyncTrash = true;
          useTracker = true;
        }
      ];
    };
  };
}
