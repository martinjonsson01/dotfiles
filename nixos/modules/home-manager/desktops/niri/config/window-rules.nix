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
    # Open picture-in-picture as unfocused floating.
    {
      matches = [
        {
          title = "^Picture in picture$";
        }
      ];
      open-floating = true;
      open-focused = false;
    }
    # Open some windows as floating.
    {
      matches = [
        {
          app-id = "^steam$";
          title = "Friends List";
        }
        {
          app-id = "^steam$";
          title = "Steam Settings";
        }
      ];
      max-width = 800;
      max-height = 800;
      open-floating = true;
    }

    #
    # Set up placement of my usual windows.
    #

    # Media
    {
      matches = [
        {
          app-id = "^google-chrome$";
          title = ".*ASMR.*YouTube.*";
        }
        {
          app-id = "^Plexamp$";
        }
      ];
      open-on-workspace = "media";
      default-column-width = {proportion = 1.0 / 2.0;};
    }
    # Statuses
    {
      matches = [
        {
          app-id = "^google-chrome$";
          title = ".*| Proton Mail - Google Chrome$";
        }
      ];
      open-on-workspace = "statuses";
      default-column-width = {proportion = 1.0;};
      default-window-height = {proportion = 1.0 / 4.0;};
    }
    {
      matches = [
        {
          app-id = "^google-chrome$";
          title = "Actual - Google Chrome$";
        }
        {
          app-id = "^google-chrome$";
          title = "WhatsApp - Google Chrome$";
        }
        {
          app-id = "^google-chrome$";
          title = ".*MyAnimeList.net - Google Chrome$";
        }
        {
          app-id = "^google-chrome$";
          title = "^Google Kalender.*";
        }
      ];
      open-on-workspace = "statuses";
      default-column-width = {proportion = 1.0;};
      default-window-height = {proportion = 3.0 / 4.0;};
    }
  ];
}
