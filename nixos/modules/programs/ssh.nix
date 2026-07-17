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
        settings = {
          "*" = {
            IdentityFile = ["~/.ssh/id_ed25519"];
            AddKeysToAgent = "yes"; # Automatically add keys to ssh-agent as necessary
          };

          "dev.antmicro.com" = {
            IdentityFile = ["~/.ssh/id_mjonsson"];
            IdentitiesOnly = true;
            WarnWeakCrypto = "no";
          };

          "github.com" = {
            User = "git";
            HostName = "github.com";
          };

          "github.com-antmicro" = {
            IdentityFile = ["~/.ssh/id_mjonsson"];
            IdentitiesOnly = true;
            HostName = "github.com";
          };
        };
      };
    };
  };
}
