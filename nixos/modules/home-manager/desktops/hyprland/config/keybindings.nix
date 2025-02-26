{
  config,
  resizeMode,
  pkgs,
}: {
  bindm = [
    # Super+mouse to drag/resize floating windows
    "SUPER, mouse:272, movewindow"
    "SUPER, mouse:273, resizewindow"
  ];
  bind =
    [
      # Kill focused window
      "SUPER, W, killactive,"

      # Change focus around
      "SUPER, left, movefocus, l"
      "SUPER, down, movefocus, d"
      "SUPER, up, movefocus, u"
      "SUPER, right, movefocus, r"

      # Move the focused window with the same, but add Shift
      "SUPER SHIFT, left, swapwindow, l"
      "SUPER SHIFT, down, swapwindow, d"
      "SUPER SHIFT, up, swapwindow, u"
      "SUPER SHIFT, right, swapwindow, r"

      # Group management
      "SUPER, g, togglegroup"
      "SUPER, t, lockactivegroup, toggle"
      "SUPER, tab, changegroupactive, f"
      "SUPERS HIFT, tab, changegroupactive, b"

      # Next/previous (nonempty) workspace
      "ALT CTRL, right, workspace, m+1"
      "ALT CTRL, left, workspace, m-1"

      # Move the currently focused window to next/previous workspace
      "ALT SHIFT, right, movetoworkspace, r+1"
      "ALT SHIFT, left, movetoworkspace, r-1"

      # Toggle fullscreen mode
      "SUPER SHIFT, f, fullscreen, 1"

      # Toggle floating mode
      "SUPER SHIFT, space, togglefloating,"

      # Move the currently focused window to the scratchpad
      "SUPER SHIFT, p, movetoworkspacesilent, special"

      # Show the next scratchpad window or hide the focused scratchpad window
      "SUPER, p, togglespecialworkspace,"

      # Reload the configuration file
      "SUPER SHIFT, c, execr, hyprctl reload"

      # Reload rendering
      "SUPER SHIFT, r, forcerendererreload,"

      # Most used applications
      "SUPER, t, exec, ${pkgs.kitty}/bin/kitty" # kitty the terminal emulator
      "SUPER, e, exec, ${pkgs.xfce.thunar}/bin/thunar" # file explorer

      # Rofi as dmenu replacement
      "SUPER, Space, exec, ${config.programs.rofi.package}/bin/rofi -show drun"
      "SUPER, Escape, exec, ${config.programs.rofi.package}/bin/rofi -show drun"

      # Modes
      "SUPER SHIFT, r, submap, ${resizeMode}"

      # Logout menu
      "CTRL SUPER, delete, exec, ${pkgs.nwg-bar}/bin/nwg-bar"
    ]
    ++ (
      # Workspaces
      # binds SUPER + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (builtins.genList (
          i: let
            ws = i + 1;
          in [
            "SUPER, code:1${toString i}, workspace, ${toString ws}"
            "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9)
    );
}
