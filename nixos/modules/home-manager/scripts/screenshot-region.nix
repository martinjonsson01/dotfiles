#
# A Wayland area screenshot script.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  screenshot-region = pkgs.writers.writeBashBin "screenshot-region.sh" ''
    set -eum

    # Use the color picker to freeze all screens.
    {
        # Make sure picker exits when this background process is killed.
        #trap 'echo exiting' EXIT

        color=$(${getExe pkgs.hyprpicker} --render-inactive --no-zoom)

        # If picker exits with no color, escape was pressed.
        if [ "$color" = "" ]; then
            # Kill the region picker, so user doesn't
            # need to press escape twice.
            pkill -x ${builtins.baseNameOf (getExe pkgs.slurp)}
        fi
    } &
    picker_pid=$!
    sleep 0.1 # it needs time to freeze the screen...

    geometry="$(${getExe pkgs.slurp} -c '#ff3f3faf' -w 2 -d -o)"
    sleep 0.1 # slurp needs time to remove the red border...

    YEAR=$(date +%Y)
    MONTH=$(date +%b)
    DAY=$(date +%d)
    TIME=$(date +'%H:%M:%S')

    TEMP_PATH="/tmp/screenshot-$YEAR-$MONTH-$DAY-$TIME.png"
    FINAL_PATH="$HOME/Pictures/Screenshots/$YEAR/$MONTH/$DAY-$TIME.png"

    mkdir -p $HOME/Pictures/Screenshots/$YEAR
    mkdir -p $HOME/Pictures/Screenshots/$YEAR/$MONTH

    if [ -n "$geometry" ]; then
        ${getExe pkgs.grim} -g "$geometry" -t png $TEMP_PATH
    else
        ${getExe pkgs.grim} -t png $TEMP_PATH
    fi

    # Kill the color picker running in the background.
    kill -- -$picker_pid # The "-" makes it kill the entire process group.

    # If screenshot was canceled, exit.
    if [ ! -f $TEMP_PATH ]; then
      echo "Screenshot canceled"
      exit
    fi

    # Edit with swappy, save as file and copy to clipboard.
    swappy -f $TEMP_PATH -o - | tee $FINAL_PATH | wl-copy

    # Clean up temp file.
    rm $TEMP_PATH
  '';
in {
  options = {
    screenshot-region.enable = mkEnableOption "Enables screenshot-region";
  };

  config = mkIf config.screenshot-region.enable {
    home.packages = [
      pkgs.wl-clipboard # To use wl-copy in the script
      screenshot-region
    ];
  };
}
