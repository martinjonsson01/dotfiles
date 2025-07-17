{config}: {
  window-rules = let
    colors = config.lib.stylix.colors.withHashtag;
  in [
    # Add border radius to windows.
    {
      draw-border-with-background = false;
      geometry-corner-radius = let
        r = 16.0;
      in {
        top-left = r;
        top-right = r;
        bottom-left = r;
        bottom-right = r;
      };
      clip-to-geometry = true;
    }
    # Open some apps in wide mode.
    {
      matches = [
        {
          app-id = "^Code$";
        }
      ];
      default-column-width = {proportion = 1.0 / 2.0;};
    }
  ];
}
