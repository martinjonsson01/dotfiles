#
# Opens the current month's screenshot directory.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  niri-rename-workspace = pkgs.writeShellApplication {
    name = "niri-rename-workspace.sh";
    runtimeInputs = [
      pkgs.fuzzel
      pkgs.gawk
    ];
    text = ''
      set -o errexit  # abort on nonzero exitstatus
      set -o nounset  # abort on unbound variable
      set -o pipefail # don't hide errors within pipes

      # If fuzzel is canceled, abort and do nothing
      # If fuzzel input is empty, unset workspace name
      # Else rename workspace with provided name
      response=$(fuzzel --dmenu --prompt-only "Rename workspace to: ")
      trimmed=$(awk '{$1=$1;print}' <<<"$response")
      if [ "$trimmed" = "" ]; then
        niri msg action unset-workspace-name
      else
        niri msg action set-workspace-name "$response"
      fi
    '';
  };
in {
  options = {
    niri-rename-workspace.enable = mkEnableOption "Enables niri-rename-workspace";
  };

  config = mkIf config.niri-rename-workspace.enable {
    home.packages = [
      niri-rename-workspace
    ];
  };
}
