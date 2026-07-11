#
# Continuous file sync between the machines and the NAS. Runs as martin
# (a dedicated daemon user caused the Resilio permission failures this
# replaces). Device identities are pre-generated and stored in sops so
# device IDs survive reinstalls; the IDs themselves are public.
#
{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.syncthing;
  host = toLower config.networking.hostName;
in {
  options.eclipse.syncthing = {
    enable = mkEnableOption "Syncthing continuous file sync";

    driveDir = mkOption {
      type = types.str;
      default = "/home/martin/Drive";
      description = "Local path of the synced Drive folder.";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "syncthing-cert" = {
        sopsFile = ./../../secrets/syncthing.yaml;
        key = "${host}-cert";
        owner = "martin";
      };
      "syncthing-key" = {
        sopsFile = ./../../secrets/syncthing.yaml;
        key = "${host}-key";
        owner = "martin";
      };
    };

    services.syncthing = {
      enable = true;
      user = "martin";
      group = "users";
      dataDir = "/home/martin";
      cert = config.sops.secrets."syncthing-cert".path;
      key = config.sops.secrets."syncthing-key".path;
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;

      settings = {
        devices = {
          Femto.id = "M6VEEVZ-FWYTXUL-TUZD5KA-WEFKRJD-L3RE3MR-QPRYSNE-3T4OWJ6-OCLM7AB";
          Idea.id = "65Q56VR-PD6H2VT-JZNWZOM-LYZLJBK-AAIAY4T-NDWN5NV-6O2AJHK-4NNORQK";
          NAS.id = "R23AYZE-BHR4JAW-3UUL674-MSXLFID-476VPSI-IO5H2VW-SLPFQUD-7BREOAA";
        };

        folders."Drive" = {
          id = "drive";
          path = cfg.driveDir;
          devices = ["Femto" "Idea" "NAS"];
          versioning = {
            type = "staggered";
            params.maxAge = "2592000"; # 30 days
          };
        };

        options.urAccepted = -1;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.driveDir} 0755 martin users -"
      "L+ ${cfg.driveDir}/.stignore - - - - ${./_syncthing/stignore}"
    ];
  };
}
