let
  gapWidth = 16;
in {
  layout = {
    # Spacing between windows.
    gaps = gapWidth;

    # Spacing between monitor edges.
    struts = {
      top = -gapWidth + 2;
      left = 0;
      bottom = -gapWidth + 2;
      right = 0;
    };

    # When to center a column when changing focus.
    center-focused-column = "on-overflow"; # focusing a column will center it if it doesn't fit on screen together with the previously focused column.

    # Always center a single column on a workspace.
    always-center-single-column = true;

    # So the wallpaper is viewable.
    background-color = "transparent";

    # Hide border around windows.
    border.enable = false;
    # Show ring around focused windows.
    focus-ring = {
      width = 1;
      active.color = "#7fc8ff";
      inactive.color = "#505050";
    };

    # Shadow rendered behind a window.
    shadow = {
      enable = true;
      color = "#0007";
      softness = 20;
      spread = 5;
      offset = {
        x = 0;
        y = 5;
      };
    };
  };
}
