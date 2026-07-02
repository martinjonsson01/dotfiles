#
# Prompts for a query and then opens the browser with a google search of it.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  search-google = pkgs.writers.writeBashBin "search-google.sh" ''
    set -o errexit   # abort on nonzero exitstatus
    set -o nounset   # abort on unbound variable
    set -o pipefail  # don't hide errors within pipes

    query=$(${getExe pkgs.fuzzel} --dmenu --prompt-only "Google: " | ${getExe pkgs.jq} --raw-output --raw-input @uri)
    ${getExe pkgs.google-chrome} --new-window "https://www.google.com/search?q=$query"
  '';
in {
  options = {
    search-google.enable = mkEnableOption "Enables search-google";
  };

  config = mkIf config.search-google.enable {
    home.packages = [
      search-google
    ];
  };
}
