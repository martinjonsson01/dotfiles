#
# Renames the currently active niri workspace.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.niri-rename-workspace.enable = mkEnableOption "niri-rename-workspace";

  config = mkIf config.eclipse.niri-rename-workspace.enable {
    eclipse.hm = {pkgs, ...}: let
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
          response=$(echo "Unset" | fuzzel --dmenu --prompt "Rename workspace to: " --lines=1)
          trimmed=$(awk '{$1=$1;print}' <<<"$response")
          if [ "$trimmed" = "Unset" ]; then
            niri msg action unset-workspace-name
          else
            niri msg action set-workspace-name "$response"
          fi
        '';
      };
    in {
      home.packages = [
        niri-rename-workspace
      ];
    };
  };
}
