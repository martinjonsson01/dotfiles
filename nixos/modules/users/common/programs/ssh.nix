#
# SSH config.
#
{
  lib,
  config,
  ...
}: {
  options = {
    ssh.enable = lib.mkEnableOption "Enables ssh";
  };

  config = lib.mkIf config.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false; # Defaults will be removed in the future
      matchBlocks = {
        "*" = {
          identityFile = ["~/.ssh/id_ed25519"];
          addKeysToAgent = "yes"; # Automatically add keys to ssh-agent as necessary
        };

        "dev.antmicro.com" = {
          identityFile = ["~/.ssh/id_mjonsson"];
          identitiesOnly = true;
          extraOptions.WarnWeakCrypto = "no";
        };

        "github.com" = {
          user = "git";
          hostname = "github.com";
        };

        "github.com-antmicro" = {
          identityFile = ["~/.ssh/id_mjonsson"];
          identitiesOnly = true;
          hostname = "github.com";
        };
      };
    };
  };
}
