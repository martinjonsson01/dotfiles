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
    map mkCmd ([
        # To support X11 applications
        "${getExe pkgs.xwayland-satellite}"

        ["${getExe pkgs.discord}" "--start-minimized"]
        ["${getExe pkgs.slack}" "--silent" "--startup"]
        "${getExe pkgs.google-chrome}"
        "${getExe pkgs.vscode}"

        # Waybar status bar
        ["sh" "-c" "pidof" "${getExe pkgs.waybar}" "||" "${getExe pkgs.waybar}"]

        # Script that applies window rules to apps that set titles late
        "${getExe (
          pkgs.writers.writePython3Bin
          "dynamic-window-rules" {libraries = [];}
          ./dynamic-window-rules.py
        )}"
      ]
      # Wallpapers
      ++ builtins.map (
        monitor: ["${getExe pkgs.swaybg}" "-o" "${monitor.connector}" "-i" "${monitor.wallpaper}"]
      ) (
        builtins.filter (m: m.wallpaper != null) myHardware.monitors
      )
      ++
      # Focus default workspace for reach monitor
      builtins.map (
        monitor: ["${getExe pkgs.niri}" "msg" "action" "focus-workspace" "${(head monitor.workspaces).name}"]
      )
      myHardware.monitors);
}
