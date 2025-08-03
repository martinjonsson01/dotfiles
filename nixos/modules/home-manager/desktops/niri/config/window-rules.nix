{config}: {
  window-rules = [
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
        {app-id = "^Code$";}
      ];
      default-column-width = {proportion = 3.0 / 7.0;};
    }
    # Open picture-in-picture as unfocused floating.
    {
      matches = [
        {title = "^Picture in picture$";}
      ];
      open-floating = true;
      open-focused = false;
    }
    #  Open some windows as floating.
    {
      matches = [
        {app-id = "^steam$";}
        {app-id = "^qalculate-gtk$";}
        {app-id = "^fsearch$";}
        {app-id = "^org.gnome.NautilusPreviewer$";}
        {app-id = "^org.gnome.Nautilus$";}
        {title = "^Bitwarden$";}
        {app-id = "^songrec$";}
        {app-id = "^vlc$";}
        {
          app-id = "^jetbrains-rustrover$";
          title = "^ $";
        }
        {
          app-id = "^jetbrains-rustrover$";
          title = "^win[0-9]+$";
        }
      ];
      excludes = [
        {
          app-id = "^steam$";
          title = "^Steam$";
        }
      ];
      open-floating = true;
    }
    # Notifications
    {
      matches = [
        {
          # Empty app-id and title for some chrome notifications
          app-id = "^$";
          title = "^$";
        }
      ];
      open-floating = true;
      open-focused = false;
      default-floating-position = {
        x = 32;
        y = 32;
        relative-to = "top-right";
      };
    }

    # Media
    {
      matches = [
        {app-id = "^Plexamp$";}
      ];
      open-on-workspace = "media";
      default-column-width = {proportion = 1.0 / 2.0;};
    }
  ];
}
