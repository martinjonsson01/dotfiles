{...}: {
  myHardware = {
    cpu = "amd";
    monitors = [
      {
        name = "Samsung Electric Company C49RG9x H1AK500000";
        connector = "DP-6";
        width = 2560;
        height = 1440;
        primary = true;
        x = 0;
        workspaces = [
          {
            id = 0;
            name = "default";
          }
        ];
      }
      {
        name = "Samsung Electric Company S24F350 H4ZR100448";
        connector = "HDMI-A-2";
        width = 2560;
        height = 1440;
        x = 2560;
        workspaces = [
          {
            id = 1;
            name = "default";
          }
        ];
      }
    ];

    audio = {
      # List sink IDs using `wpctl status`
      # Get sink node.name using `wpctl inspect [ID]`
      disabledMatches = [
      ];

      sinkPriorityMatches = [
      ];
    };
  };
}
