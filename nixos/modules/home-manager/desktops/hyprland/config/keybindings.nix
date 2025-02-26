{
  config,
  resizeMode,
  pkgs,
}: {
  # [m] for binds that rely on mouse movement.
  bindm = [
    # Super+mouse to drag/resize floating windows
    "SUPER, mouse:272, movewindow"
    "SUPER, mouse:273, resizewindow"
  ];

  # [n] for non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
  bindn = [
    ", mouse:272, hy3:focustab, mouse"
    ", mouse_down, hy3:focustab, l, require_hovered"
    ", mouse_up, hy3:focustab, r, require_hovered"
  ];

  # [r] for release, will trigger on release of a key.
  bindr = [
    # Stop previewing tab titles
    "SUPER, o, exec, hyprctl keyword plugin:hy3:tabs:height 2"
    "SUPER, o, exec, hyprctl keyword plugin:hy3:tabs:render_text false"
  ];

  bind =
    [
      # Show tab titles
      "SUPER, i, exec, hyprctl keyword plugin:hy3:tabs:height 20"
      "SUPER, i, exec, hyprctl keyword plugin:hy3:tabs:render_text true"
      # Preview tab titles
      "SUPER, o, exec, hyprctl keyword plugin:hy3:tabs:height 20"
      "SUPER, o, exec, hyprctl keyword plugin:hy3:tabs:render_text true"

      # Kill focused window
      "SUPER, W, killactive,"

      # Move focus to only visible nodes, not hidden tabs
      "SUPER, left, hy3:movefocus, l, visible, nowarp"
      "SUPER, down, hy3:movefocus, d, visible, nowarp"
      "SUPER, up, hy3:movefocus, u, visible, nowarp"
      "SUPER, right, hy3:movefocus, r, visible, nowarp"

      # Move window only directly to neighboring group,
      # without moving into any of its subgroups
      "SUPER+SHIFT, left, hy3:movewindow, l, once"
      "SUPER+SHIFT, down, hy3:movewindow, d, once"
      "SUPER+SHIFT, up, hy3:movewindow, u, once"
      "SUPER+SHIFT, right, hy3:movewindow, r, once"

      # Move window only to neighboring, only to visible
      "SUPER+CONTROL+SHIFT, left, hy3:movewindow, l, once, visible"
      "SUPER+CONTROL+SHIFT, down, hy3:movewindow, d, once, visible"
      "SUPER+CONTROL+SHIFT, up, hy3:movewindow, u, once, visible"
      "SUPER+CONTROL+SHIFT, right, hy3:movewindow, r, once, visible"

      # Group management
      "SUPER, d, hy3:makegroup, h"
      "SUPER, s, hy3:makegroup, v"
      "SUPER, z, hy3:makegroup, tab"
      "SUPER, a, hy3:changefocus, raise"
      "SUPER+SHIFT, a, hy3:changefocus, lower"
      "SUPER, e, hy3:expand, expand"
      "SUPER+SHIFT, e, hy3:expand, base"
      "SUPER, r, hy3:changegroup, opposite"

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
      "SUPER SHIFT, b, forcerendererreload,"

      # Most used applications
      "SUPER, t, exec, ${pkgs.kitty}/bin/kitty" # kitty the terminal emulator
      # "SUPER, e, exec, ${pkgs.xfce.thunar}/bin/thunar" # file explorer

      # Rofi as dmenu replacement
      "SUPER, Space, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -show drun"
      "SUPER, Tab, exec, ${config.programs.rofi.package}/bin/rofi -show window"

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
