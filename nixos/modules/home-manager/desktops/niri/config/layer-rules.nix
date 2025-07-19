{
  layer-rules = [
    {
      matches = [{namespace = "^wallpaper$";}];

      place-within-backdrop = true;
    }
    {
      matches = [
        {namespace = "^swaync-notification-window$";}
        {namespace = "^swaync-control-center$";}
      ];

      block-out-from = "screen-capture";
    }
  ];
}
