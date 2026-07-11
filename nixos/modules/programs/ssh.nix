#
# SSH config.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.ssh.enable = mkEnableOption "ssh";

  config = mkIf config.eclipse.ssh.enable {
    eclipse.hm = {
      imports = [../../secrets/ssh.nix];

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
  };
}
