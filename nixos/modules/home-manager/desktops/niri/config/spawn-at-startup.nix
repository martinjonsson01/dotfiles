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

        # Waybar status bar
        ["sh" "-c" "pidof" "${getExe pkgs.waybar}" "||" "${getExe pkgs.waybar}"]

        "${getExe pkgs.plexamp}"

        "${getExe pkgs.google-chrome}"

        "${getExe pkgs.discord}"

        "${getExe pkgs.slack}"
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
