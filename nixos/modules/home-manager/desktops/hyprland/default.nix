{
  config,
  lib,
  ...
}: {
  imports = [
    ./binds.nix
    ./plugins.nix
  ];

  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland";
    hyprland.nvidia.enable = lib.mkEnableOption "Enables nvidia support for Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.kitty.enable = true; # required for the default Hyprland config

    # Hint Electron apps to use Wayland.
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    wayland.windowManager.hyprland = {
      enable = true;

      # Using UWSM instead.
      systemd.enable = false;

      settings = {
        env =
          lib.optionals (config.hyprland.nvidia.enable) [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          ]
          ++ [
            "XDG_SESSION_TYPE,wayland"
            "NIXOS_OZONE_WL,1"
            "MOZ_ENABLE_WAYLAND,1"
            "_JAVA_AWT_WM_NONREPARENTING,1"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_QPA_PLATFORM,wayland"
            "GDK_BACKEND,wayland"
          ];
      };
    };
  };
}
