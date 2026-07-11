#
# Prompts for a query and then opens the browser with a github nix-filtered search of it.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.search-github-nix.enable = mkEnableOption "search-github-nix";

  config = mkIf config.eclipse.search-github-nix.enable {
    eclipse.hm = {pkgs, ...}: let
      search-github-nix = pkgs.writers.writeBashBin "search-github-nix.sh" ''
        set -o errexit   # abort on nonzero exitstatus
        set -o nounset   # abort on unbound variable
        set -o pipefail  # don't hide errors within pipes

        query=$(${getExe pkgs.fuzzel} --dmenu --prompt-only "GitHub Nix: " | ${getExe pkgs.jq} --raw-output --raw-input @uri)
        plus_query=''${query//%20/+}
        ${getExe pkgs.google-chrome} --new-window "https://github.com/search?q=language%3Anix+$plus_query&type=code"
      '';
    in {
      home.packages = [
        search-github-nix
      ];
    };
  };
}
