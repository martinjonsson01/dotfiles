{
  pkgs,
  myHardware,
}: {
  spawn-at-startup =
    [
      # To support X11 applications
      {command = ["${pkgs.xwayland-satellite}/bin/xwayland-satellite"];}
      # Waybar status bar
      {command = ["pidof ${pkgs.waybar}/bin/waybar || ${pkgs.waybar}/bin/waybar"];}
    ]
    # Wallpapers
    ++ builtins.map (
      monitor: {
        command = ["${pkgs.swaybg}/bin/swaybg -o ${monitor.connector} -i ${monitor.wallpaper}"];
      }
    ) (
      builtins.filter (m: m.wallpaper != null) myHardware.monitors
    );
}
