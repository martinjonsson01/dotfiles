{
  lib,
  config,
  pkgs,
}:
with lib; {
  binds = with config.lib.niri.actions; let
    niri = "${config.programs.niri.package}/bin/niri";
  in {
    # Keys consist of modifiers separated by + signs, followed by an XKB key name
    # in the end. To find an XKB name for a particular key, you may use a program
    # like wev.
    #
    # "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
    # when running as a winit window.
    #
    # Most actions that you can bind here can also be invoked programmatically with
    # `niri msg action do-something`.

    # Binding shifted keys requires spelling out Shift and the unshifted version of the key.
    # Mod-? shows a list of important hotkeys.
    "Mod+Shift+plus".action = show-hotkey-overlay;

    # Binds for running programs: terminal, app launcher, screen locker.
    "Mod+Return".action = spawn "${getExe pkgs.kitty}";
    "Mod+D".action = spawn "${getExe pkgs.fuzzel}";
    "Mod+L".action = spawn "${getExe pkgs.nwg-bar}";
    "Mod+S".action = spawn "${getExe pkgs.fsearch}";
    "Mod+Tab".action = spawn ["${getExe pkgs.rofi}" "-show" "window"];
    "Mod+E".action = spawn ["${getExe pkgs.nautilus}" "--new-window"];
    "Mod+Space".action = spawn "${getExe pkgs.qalculate-gtk}";

    # Volume keys mappings for PipeWire & WirePlumber.
    # The allow-when-locked=true property makes them work even when the session is locked.
    XF86AudioRaiseVolume = {
      action = spawn ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
      allow-when-locked = true;
    };
    XF86AudioLowerVolume = {
      action = spawn ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
      allow-when-locked = true;
    };
    XF86AudioMute = {
      action = spawn ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      allow-when-locked = true;
    };
    XF86AudioMicMute = {
      action = spawn ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
      allow-when-locked = true;
    };

    "Mod+W".action = close-window;

    # Focus using directional keys.
    "Mod+Left".action = focus-column-left;
    "Mod+Down".action = focus-window-or-workspace-down;
    "Mod+Up".action = focus-window-or-workspace-up;
    "Mod+Right".action = focus-column-right;

    # Move using ctrl + directional keys.
    "Mod+Ctrl+Left".action = move-column-left;
    "Mod+Ctrl+Down".action = move-window-down-or-to-workspace-down;
    "Mod+Ctrl+Up".action = move-window-up-or-to-workspace-up;
    "Mod+Ctrl+Right".action = move-column-right;

    # Move/focus first/last.
    "Mod+Home".action = focus-column-first;
    "Mod+End".action = focus-column-last;
    "Mod+Ctrl+Home".action = move-column-to-first;
    "Mod+Ctrl+End".action = move-column-to-last;

    # Focus different monitors.
    "Mod+Shift+Left".action = focus-monitor-left;
    "Mod+Shift+Down".action = focus-monitor-down;
    "Mod+Shift+Up".action = focus-monitor-up;
    "Mod+Shift+Right".action = focus-monitor-right;

    # Move to different monitors.
    "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
    "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
    "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
    "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;

    # Focus on/move to different workspaces.
    "Mod+Page_Down".action = focus-workspace-down;
    "Mod+Page_Up".action = focus-workspace-up;
    "Mod+U".action = focus-workspace-down;
    "Mod+I".action = focus-workspace-up;
    "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
    "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
    "Mod+Ctrl+U".action = move-column-to-workspace-down;
    "Mod+Ctrl+I".action = move-column-to-workspace-up;

    # Move entire workspaces.
    "Mod+Shift+Page_Down".action = move-workspace-down;
    "Mod+Shift+Page_Up".action = move-workspace-up;
    "Mod+Shift+N".action = move-workspace-down;
    "Mod+Shift+P".action = move-workspace-up;

    # Focus on/move to different workspaces using scroll wheel.
    "Mod+WheelScrollDown" = {
      cooldown-ms = 150;
      action = focus-workspace-down;
    };
    "Mod+WheelScrollUp" = {
      cooldown-ms = 150;
      action = focus-workspace-up;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      cooldown-ms = 150;
      action = move-column-to-workspace-down;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      cooldown-ms = 150;
      action = move-column-to-workspace-up;
    };

    # Sideways scrolling.
    "Mod+WheelScrollRight".action = focus-column-right;
    "Mod+WheelScrollLeft".action = focus-column-left;
    "Mod+Ctrl+WheelScrollRight".action = move-column-right;
    "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

    # Usually scrolling up and down with Shift in applications results in
    # horizontal scrolling; these binds replicate that.
    "Mod+Shift+WheelScrollDown".action = focus-column-right;
    "Mod+Shift+WheelScrollUp".action = focus-column-left;
    "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
    "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

    # Refer to workspaces by index.
    "Mod+1".action = focus-workspace 1;
    "Mod+2".action = focus-workspace 2;
    "Mod+3".action = focus-workspace 3;
    "Mod+4".action = focus-workspace 4;
    "Mod+5".action = focus-workspace 5;
    "Mod+6".action = focus-workspace 6;
    "Mod+7".action = focus-workspace 7;
    "Mod+8".action = focus-workspace 8;
    "Mod+9".action = focus-workspace 9;
    "Mod+Ctrl+1".action = spawn [niri "msg" "action" "move-column-to-workspace" "1"];
    "Mod+Ctrl+2".action = spawn [niri "msg" "action" "move-column-to-workspace" "2"];
    "Mod+Ctrl+3".action = spawn [niri "msg" "action" "move-column-to-workspace" "3"];
    "Mod+Ctrl+4".action = spawn [niri "msg" "action" "move-column-to-workspace" "4"];
    "Mod+Ctrl+5".action = spawn [niri "msg" "action" "move-column-to-workspace" "5"];
    "Mod+Ctrl+6".action = spawn [niri "msg" "action" "move-column-to-workspace" "6"];
    "Mod+Ctrl+7".action = spawn [niri "msg" "action" "move-column-to-workspace" "7"];
    "Mod+Ctrl+8".action = spawn [niri "msg" "action" "move-column-to-workspace" "8"];
    "Mod+Ctrl+9".action = spawn [niri "msg" "action" "move-column-to-workspace" "9"];

    # The following binds move the focused window in and out of a column.
    # If the window is alone, they will consume it into the nearby column to the side.
    # If the window is already in a column, they will expel it out.
    "Mod+BracketLeft".action = consume-or-expel-window-left;
    "Mod+BracketRight".action = consume-or-expel-window-right;
    # Consume one window from the right to the bottom of the focused column.
    "Mod+Comma".action = consume-window-into-column;
    # Expel the bottom window from the focused column to the right.
    "Mod+Period".action = expel-window-from-column;

    "Mod+R".action = switch-preset-column-width;
    "Mod+Shift+R".action = switch-preset-window-height;
    "Mod+Ctrl+R".action = reset-window-height;
    "Mod+F".action = maximize-column;
    "Mod+Shift+F".action = fullscreen-window;
    # Expand the focused column to space not taken up by other fully visible columns.
    # Makes the column "fill the rest of the space".
    "Mod+Ctrl+F".action = expand-column-to-available-width;

    "Mod+Shift+C".action = center-column;
    # Finer width adjustments.
    # This command can also:
    # * set width in pixels: "1000"
    # * adjust width in pixels: "-5" or "+5"
    # * set width as a percentage of screen width: "25%"
    # * adjust width as a percentage of screen width: "-10%" or "+10%"
    # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
    # set-column-width "100" will make the column occupy 200 physical screen pixels.
    "Mod+Apostrophe".action = set-column-width "-5%";
    "Mod+Dead_diaeresis".action = set-column-width "+5%";

    # Finer height adjustments when in column with other windows.
    "Mod+Shift+Apostrophe".action = set-window-height "-5%";
    "Mod+Shift+Dead_diaeresis".action = set-window-height "+5%";

    # Move the focused window between the floating and the tiling layout.
    "Mod+V".action = toggle-window-floating;
    "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

    # Toggle tabbed column display mode.
    # Windows in this column will appear as vertical tabs,
    # rather than stacked on top of each other.
    "Mod+C".action = toggle-column-tabbed-display;

    # Actions to switch layouts.
    # Note: if you uncomment these, make sure you do NOT have
    # a matching layout switch hotkey configured in xkb options above.
    # Having both at once on the same hotkey will break the switching,
    # since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
    # "Mod+At".action = switch-layout "next";
    # Mod+Shift+Space { switch-layout "prev"; }

    "Print".action = screenshot;
    "Alt+Print".action = screenshot-window;

    # Applications such as remote-desktop clients and software KVM switches may
    # request that niri stops processing the keyboard shortcuts defined here
    # so they may, for example, forward the key presses as-is to a remote machine.
    # It's a good idea to bind an escape hatch to toggle the inhibitor,
    # so a buggy application can't hold your session hostage.
    #
    # The allow-inhibiting=false property can be applied to other binds as well,
    # which ensures niri always processes them, even when an inhibitor is active.
    "Mod+Escape" = {
      allow-inhibiting = false;
      action = toggle-keyboard-shortcuts-inhibit;
    };

    # The quit action will show a confirmation dialog to avoid accidental exits.
    "Mod+Shift+E".action = quit;
    "Ctrl+Alt+Delete".action = quit;

    # Powers off the monitors. To turn them back on, do any input like
    # moving the mouse or pressing any other key.
    "Mod+Shift+M".action = power-off-monitors;
  };
}
