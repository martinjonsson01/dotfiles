{...}: {
  myHardware = {
    cpu = "amd";
    monitors = [
      {
        name = "Dell Inc. DELL P2723D 3N5DG04";
        connector = "DP-2";
        width = 2560;
        height = 1440;
        primary = true;
        x = 0;
        workspaces = [
          {
            id = 0;
            name = "default0";
          }
        ];
      }
      {
        name = "Dell Inc. DELL P2723D BTRDG04";
        connector = "HDMI-A-1";
        width = 2560;
        height = 1440;
        x = 2560;
        workspaces = [
          {
            id = 1;
            name = "default1";
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
