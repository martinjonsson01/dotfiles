#
# Locks the computer, shutting off displays.
#
{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
with lib; let
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
        pkill slack  # Kill slack so my status updates correctly.
        niri msg action power-off-monitors  # Can't use real suspend on this host, it just wakes up again.
        ${getExe config.programs.swaylock.package} 
        slack & disown  # Restart slack, but don't kill it when the script finishes.
      else
        systemctl suspend
      fi
    '';
  };
in {
  options = {
    lock-script.enable = mkEnableOption "Enables lock script";
  };

  config = mkIf config.lock-script.enable {
    home.packages = [
      lock-script
    ];
  };
}
