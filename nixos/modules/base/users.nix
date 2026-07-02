#
# Users as data: user modules declare their facts under eclipse.users, hosts
# just flip enable. Bridges below generate the actual accounts and fan the
# merged eclipse.hm module out to every enabled user, so other modules can
# contribute user-level configuration without naming any user.
#
{
  config,
  lib,
  ...
}:
with lib; let
  enabledUsers = filterAttrs (_: user: user.enable) config.eclipse.users;
in {
  options.eclipse = {
    users = mkOption {
      description = "The users of this host.";
      default = {};
      type = types.attrsOf (types.submodule ({name, ...}: {
        options = {
          enable = mkEnableOption "this user account";
          description = mkOption {
            type = types.str;
            default = name;
          };
          uid = mkOption {
            type = types.nullOr types.int;
            default = null;
          };
          extraGroups = mkOption {
            type = types.listOf types.str;
            default = [];
          };
          sshKeyPath = mkOption {
            description = "SSH key that sops imports as an age key.";
            type = types.str;
            default = "/home/${name}/.ssh/id_ed25519";
          };
          authorizedKeyFiles = mkOption {
            description = "SSH public keys allowed to log in as this user.";
            type = types.listOf types.path;
            default = [];
          };
          stateVersion = mkOption {
            description = "Home Manager state version, do not change after install.";
            type = types.str;
          };
        };
      }));
    };

    hm = mkOption {
      description = "Home Manager module applied to every enabled user.";
      type = types.deferredModule;
      default = {};
    };
  };

  config = {
    users = {
      users =
        mapAttrs (name: user: {
          isNormalUser = true;
          inherit (user) description uid extraGroups;
          openssh.authorizedKeys.keyFiles = user.authorizedKeyFiles;
        })
        enabledUsers;

      groups = mapAttrs (name: user: {gid = user.uid;}) enabledUsers;
    };

    sops.age.sshKeyPaths = mapAttrsToList (_: user: user.sshKeyPath) enabledUsers;

    home-manager.users =
      mapAttrs (name: user: {
        imports = [config.eclipse.hm];

        home = {
          username = name;
          homeDirectory = "/home/${name}";
          stateVersion = user.stateVersion;
        };

        # Nicely reload system units when changing configs
        systemd.user.startServices = "sd-switch";

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        # Secrets management
        sops = {
          defaultSopsFile = ../../secrets/secrets.yaml;
          defaultSopsFormat = "yaml";
          age.sshKeyPaths = [user.sshKeyPath];
        };
      })
      enabledUsers;
  };
}
