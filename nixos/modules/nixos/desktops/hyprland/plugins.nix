{pkgs, ...}: {
  home-manager.users."martin".wayland.windowManager.hyprland.plugins = with pkgs.hyprlandPlugins; [
    hyprbars # Hyprland window title plugin
  ];
}
