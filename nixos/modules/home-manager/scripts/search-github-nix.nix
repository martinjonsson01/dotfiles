#
# Prompts for a query and then opens the browser with a github nix-filtered search of it.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  search-github-nix = pkgs.writers.writeBashBin "search-github-nix.sh" ''
    set -o errexit   # abort on nonzero exitstatus
    set -o nounset   # abort on unbound variable
    set -o pipefail  # don't hide errors within pipes

    query=$(${getExe pkgs.fuzzel} --dmenu --prompt-only "GitHub Nix: " | ${getExe pkgs.jq} --slurp --raw-output --raw-input @uri)
    plus_query=''${query//%20/+}
    ${getExe pkgs.google-chrome} --new-window "https://github.com/search?q=language%3Anix+$plus_query&type=code"
  '';
in {
  options = {
    search-github-nix.enable = mkEnableOption "Enables search-github-nix";
  };

  config = mkIf config.search-github-nix.enable {
    home.packages = [
      search-github-nix
    ];
  };
}
