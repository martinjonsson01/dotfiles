#
# GitHub CLI (gh)
#
{
  lib,
  config,
  ...
}: {
  options = {
    gh.enable = lib.mkEnableOption "Enables the GitHub CLI (gh)";
  };

  config = lib.mkIf config.gh.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    sops.secrets."github-token" = {
      sopsFile = ./../../../../secrets/api.yaml;
    };

    sops.templates."gh-hosts.yml".content = ''
      github.com:
          users:
              martinjonsson01:
                  oauth_token: ${config.sops.placeholder."github-token"}
          oauth_token: ${config.sops.placeholder."github-token"}
          user: martinjonsson01
          git_protocol: ssh
    '';

    home.activation.placeGhHosts = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.config/gh
      ln -sf ${config.sops.templates."gh-hosts.yml".path} $HOME/.config/gh/hosts.yml
    '';
  };
}
