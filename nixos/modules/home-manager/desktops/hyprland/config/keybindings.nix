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
      "SUPER, F4, killactive,"

      # Change focus around
      "SUPER, h, movefocus, l"
      "SUPER, j, movefocus, d"
      "SUPER, k, movefocus, u"
      "SUPER, l, movefocus, r"
      # Or use arrow keys
      "SUPER, left, movefocus, l"
      "SUPER, down, movefocus, d"
      "SUPER, up, movefocus, u"
      "SUPER, right, movefocus, r"

      # Move the focused window with the same, but add Shift
      "SUPER SHIFT, h, movewindow, l"
      "SUPER SHIFT, j, movewindow, d"
      "SUPER SHIFT, k, movewindow, u"
      "SUPER SHIFT, l, movewindow, r"
      # Or use arrow keys
      "SUPER SHIFT, left, movewindow, l"
      "SUPER SHIFT, down, movewindow, d"
      "SUPER SHIFT, up, movewindow, u"
      "SUPER SHIFT, right, movewindow, r"

      # Next/previous workspace
      "SUPER, tab, workspace, e+1"
      "SUPER SHIFT, tab, workspace, e-1"

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

      # Most used applications
      "SUPER, t, exec, ${pkgs.kitty}/bin/kitty" # kitty the terminal emulator
      "SUPER, f, exec, thunar" # use system provided thunar package

      # Rofi as dmenu replacement
      "SUPER, section, exec, ${config.programs.rofi.package}/bin/rofi -show drun"
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
