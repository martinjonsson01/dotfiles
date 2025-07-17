{
  layout = {
    # Spacing between windows.
    gaps = 16;

    # When to center a column when changing focus.
    center-focused-column = "on-overflow"; # focusing a column will center it if it doesn't fit on screen together with the previously focused column.

    # Always center a single column on a workspace.
    always-center-single-column = true;

    # The widths that the switch-preset-column-width action (Mod+R) toggles between
    preset-column-widths = [
      {proportion = 1.0 / 2.0;}
      {proportion = 1.0 / 3.0;}
      {proportion = 1.0 / 4.0;}
    ];

    # The default width of new windows.
    default-column-width = {proportion = 1.0 / 4.0;};

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
