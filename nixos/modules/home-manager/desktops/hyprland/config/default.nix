{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  myHardware = osConfig.myHardware;
  resizeMode = "Resize: (h/Left) width- (j/Down) height-, (k/Up) height+, (l/Right) width+";
in {
  # Submaps are impossible to be defined in settings
  extraConfig = ''
    # Resize window
    submap = ${resizeMode}
    binde = , h, resizeactive, -10 0
    binde = , j, resizeactive, 0 10
    binde = , k, resizeactive, 0 -10
    binde = , l, resizeactive, 10 0
    # Or use arrow keys
    binde = , left, resizeactive, -10 0
    binde = , down, resizeactive, 0 10
    binde = , up, resizeactive, 0 -10
    binde = , right, resizeactive, 10 0
    # Return to normal mode
    bind = , escape, submap, reset
    submap = reset
  '';

  settings =
    {
      # Monitor placement
      # [ "<name>,<width>x<height>,<x>x<y>,1" ... ]
      monitor =
        builtins.map (
          m: "${m.name},${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz,${toString m.x}x${toString m.y},1, transform, ${toString m.rotation}"
        )
        myHardware.monitors;

      # Wallpaper
      # [ "swaybg -o <name> -i <path>" ... ]
      exec-once =
        builtins.map (m: "${pkgs.swaybg}/bin/swaybg -o ${m.name} -i ${m.wallpaper}") (
          builtins.filter (m: m.wallpaper != null) myHardware.monitors
        )
        ++ [
          "${pkgs.waybar}/bin/waybar"
        ];

      # General settings
      general = {
        resize_on_border = true;
      };
      input = {
        numlock_by_default = true;
        follow_mouse = 1;
        kb_layout = "se";

        # Mouse config
        accel_profile = "flat"; # Disable mouse acceleration
        #scroll_points = "0.17156 0.000 0.369 0.738 1.292 1.847 2.402 3.006 3.849 4.692 5.535 6.378 7.221 8.064 8.907 9.750 10.593 11.436 12.279 13.122 14.864";
        sensitivity = 1.0; # Value is clamped to the range -1.0 to 1.0.
        scroll_method = "on_button_down"; # Middle mouse scroll
        scroll_button = 274; # Middle mouse scroll
      };
      misc = {
        # Display Power Management Signaling
        # aka turn on when I move mouse / press key
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
      env = lib.mkIf (myHardware.gpuDriver == "nvidia") [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];
    }
    // (import ./keybindings.nix {inherit config resizeMode pkgs;})
    // (import ./ws-outputs.nix {inherit osConfig;})
    // (import ./window-rules.nix)
    // (import ./appearances.nix);
}
