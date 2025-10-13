#
# Launches Kitty with its working directory set based on the currently active workspace.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  niri-launch-kitty-workspace-cwd = pkgs.writeShellApplication {
    name = "niri-launch-kitty-workspace-cwd.sh";
    runtimeInputs = with pkgs; [
      kitty
      fish
    ];
    text = ''
      set +o pipefail # Necessary due to sporadic failures in `niri msg workspaces`

      current_output_port=$(niri msg focused-output | head -n1 | sed -n 's/.*(\(.*\)).*/\1/p')
      active_workspace_name=$(niri msg workspaces | awk -v port="$current_output_port" '
        $0 ~ "Output \"" port "\":" {f=1; next}
        f && /^Output / {exit}
        f && /^\s*\*/ {match($0, /"([^"]+)"/, m); print m[1]; exit}')
      # Workspace is unnamed/couldn't be found, so launch normally.
      if [ -z "$active_workspace_name" ]; then
        ${getExe pkgs.kitty} --single-instance
        exit 0
      fi

      # Only use first segment of workspace name to find working directory.
      IFS='-' read -ra workspace_name_segments <<< "$active_workspace_name"
      workspace_identifier="''${workspace_name_segments[0]}"

      # Find workspace-related directory using the fish program `z`.
      if ! workspace_dir=$(fish -c "z --echo '$workspace_identifier'"); then
        # Just launch normally if we couldn't find a matching directory.
        ${getExe pkgs.kitty} --single-instance
        exit 0
      fi
      echo "$workspace_dir"

      ${getExe pkgs.kitty} --single-instance --working-directory "$workspace_dir"
    '';
  };
in {
  options = {
    niri-launch-kitty-workspace-cwd.enable = mkEnableOption "Enables niri-launch-kitty-workspace-cwd";
  };

  config = mkIf config.niri-launch-kitty-workspace-cwd.enable {
    home.packages = [
      niri-launch-kitty-workspace-cwd
    ];
  };
}
