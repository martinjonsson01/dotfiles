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
      addKeysToAgent = "yes"; # Automatically add keys to ssh-agent as necessary
      matchBlocks = {
        "*" = {
          identityFile = ["~/.ssh/id_ed25519"];
        };

        "dev.antmicro.com" = {
          identityFile = ["~/.ssh/id_mjonsson"];
          identitiesOnly = true;
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
