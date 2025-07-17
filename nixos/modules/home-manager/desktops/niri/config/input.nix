{
  input = {
    keyboard = {
      xkb.layout = "se";
    };

    mouse = {
      accel-profile = "flat"; # Disable mouse acceleration.
      accel-speed = 0.7; # Pointer speed.
    };

    # Focuses windows and outputs automatically when moving the mouse over them.
    focus-follows-mouse = {
      enable = true;
      # focus-follows-mouse won't focus a window if it will result in the view scrolling more than the set amount
      max-scroll-amount = "0%"; # Never focus if it'll result in scroll
    };

    # Switching to the same workspace by index twice will switch back to the previous workspace.
    workspace-auto-back-and-forth = true;
  };
}
