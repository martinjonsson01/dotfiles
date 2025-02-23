{pkgs, ...}: {
  wayland.windowManager.hyprland.plugins = with pkgs.hyprlandPlugins; [
    hyprbars # Hyprland window title plugin
  ];
}
