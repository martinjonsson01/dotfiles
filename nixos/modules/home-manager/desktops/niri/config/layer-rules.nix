{
  layer-rules = [
    # Show wallpapers in overview.
    {
      matches = [{namespace = "^wallpaper$";}];

      place-within-backdrop = true;
    }
    # Hide sensitive layers from screen recordings.
    {
      matches = [
        {namespace = "^swaync-notification-window$";}
        {namespace = "^swaync-control-center$";}
      ];

      block-out-from = "screen-capture";
    }
  ];
}
