{
  pkgs,
  lib,
  myHardware,
}:
with lib; {
  spawn-at-startup = let
    mkCmd = cmd:
      if builtins.isList cmd
      then {command = cmd;}
      else {command = singleton cmd;};
  in
    map mkCmd [
      # To support X11 applications
      "${getExe pkgs.xwayland-satellite}"
      # Waybar status bar
      ["sh" "-c" "pidof" "${getExe pkgs.waybar}" "||" "${getExe pkgs.waybar}"]
    ]
    # Wallpapers
    ++ builtins.map (
      monitor: {
        command = ["${pkgs.swaybg}/bin/swaybg" "-o" "${monitor.connector}" "-i" "${monitor.wallpaper}"];
      }
    ) (
      builtins.filter (m: m.wallpaper != null) myHardware.monitors
    );
}
