#
# A Wayland area screen recorder script.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  screenrecord-region = pkgs.writers.writeBashBin "screenrecord-region.sh" ''
    set -eu

    running=0
    pkill -x ${builtins.baseNameOf (getExe pkgs.wf-recorder)} || running=$?

    # If there was no running wf-recorder instance to kill, start recording...
    [ $running -ne 0 ] && {
        YEAR=$(date +%Y)
        MONTH=$(date +%b)
        DAY=$(date +%d)
        TIME=$(date +'%H:%M:%S')

        TEMP_PATH="/tmp/recording-$YEAR-$MONTH-$DAY-$TIME"
        FINAL_PATH="$HOME/Pictures/Screenshots/$YEAR/$MONTH/$DAY-$TIME"

        mkdir -p $HOME/Pictures/Screenshots/$YEAR
        mkdir -p $HOME/Pictures/Screenshots/$YEAR/$MONTH

        ${getExe pkgs.libnotify} -t 2000 'Screen recording' 'Select an area to start the recording...'
        geometry="$(${getExe pkgs.slurp} -c '#ff3f3faf' -w 2 -d -o)"
        sleep 0.2 # slurp needs time to remove the red border...
        pkill -RTMIN+3 -x .waybar-wrapped # Send signal 3 to waybar to show recording icon
        ${getExe pkgs.wf-recorder} -g "$geometry" -f "$FINAL_PATH.mkv"
        pkill -RTMIN+3 -x .waybar-wrapped # Send signal 3 to waybar to hide recording icon

        ${getExe pkgs.ffmpeg} -i "$FINAL_PATH.mkv" -vf "fps=15,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" "$FINAL_PATH.gif"
        ${getExe pkgs.libnotify} -t 2000 'Screen recording' "Recording is ready: $FINAL_PATH.{mkv,gif}"

        wl-copy -t image/gif < "$FINAL_PATH.gif"
        echo "file://$FINAL_PATH.mkv" | wl-copy -t text/uri-list
    } &
  '';
in {
  options = {
    screenrecord-region.enable = mkEnableOption "Enables screenrecord-region";
  };

  config = mkIf config.screenrecord-region.enable {
    home.packages = [
      pkgs.wl-clipboard # To use wl-copy in the script
      screenrecord-region
    ];
  };
}
