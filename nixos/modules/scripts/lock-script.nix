#
# Locks the computer, shutting off displays.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.lock-script.enable = mkEnableOption "lock script";

  config = mkIf config.eclipse.lock-script.enable {
    eclipse.hm = {
      pkgs,
      config,
      osConfig,
      ...
    }: let
      host = osConfig.networking.hostName;
      lock-script = pkgs.writeShellApplication {
        name = "lock-script.sh";
        runtimeInputs = with pkgs; [
          niri
          swaylock
        ];
        text = ''
          # shellcheck disable=SC2050  # When building for a given host, this expression will be constant.
          if [ "${host}" = "Idea" ]; then
            # Get current weekday (1-7, Mon=1 ... Sun=7)
            weekday=$(date +%u)
            # Get current time as HHMM integer
            now=$(date +%H%M)
            # Determine cutoff time
            if [ "$weekday" -eq 5 ]; then
                cutoff=1115   # Friday
            else
                cutoff=1330   # Other weekdays
            fi

            # Only kill Slack if after cutoff.
            if [ "$now" -ge "$cutoff" ]; then
              pkill slack  # Kill slack so my status updates correctly.
            fi

            niri msg action power-off-monitors  # Can't use real suspend on this host, it just wakes up again.
            ${getExe config.programs.swaylock.package}

            # After unlocking, relaunch Slack only if it's not already running
            if ! pgrep slack >/dev/null 2>&1; then
              slack & disown  # Start slack, but don't kill it when the script finishes.
            fi
          else
            systemctl suspend
          fi
        '';
      };
    in {
      home.packages = [
        lock-script
      ];
    };
  };
}
