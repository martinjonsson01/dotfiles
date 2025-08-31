{...}: {
  myHardware = {
    cpu = "amd";
    gpuDriver = "nvidia";
    monitors = [
      {
        name = "Acer Technologies XF270HU T78EE0048521";
        connector = "DP-5";
        width = 2560;
        height = 1440;
        refreshRate = 144.0;
        rotation = 3;
        x = 5120;
        wallpaper = ./wallpapers/kanagawa-dark.jpg;
        workspaces = [
          {
            id = 8;
            name = "statuses";
          }
        ];
      }
      {
        name = "Samsung Electric Company C49RG9x H1AK500000";
        connector = "DP-6";
        width = 5120;
        height = 1440;
        refreshRate = 120.0;
        primary = true;
        x = 0;
        wallpaper = ./wallpapers/skull2.png;
        workspaces = [
          {
            id = 1;
            name = "casual";
          }
          {
            id = 2;
            name = "nixos";
          }
          {
            id = 3;
            name = "cluster";
          }
          {
            id = 4;
            name = "project";
          }
        ];
      }
      {
        name = "Samsung Electric Company S24F350 H4ZR100448";
        connector = "HDMI-A-2";
        width = 1920;
        height = 1080;
        x = -1920;
        wallpaper = ./wallpapers/kanagawa-dark.jpg;
        workspaces = [
          {
            id = 9;
            name = "media";
          }
        ];
      }
    ];

    audio = {
      # List sink IDs using `wpctl status`
      # Get sink node.name using `wpctl inspect [ID]`
      disabledMatches = [
        "node.name = \"alsa_output.usb-Generic_USB_Audio-00.HiFi__Headphones__sink\""
        "node.name = \"alsa_output.pci-0000_01_00.1.hdmi-stereo\""
        "node.name = \"alsa_output.usb-Elgato_Systems_Elgato_Wave_3_BS01K1A01450-00.analog-stereo\""
        "device.nick = \"HDA NVidia\""
        "device.name = \"alsa_card.pci-0000_10_00.1\""
      ];

      sinkPriorityMatches = [
        "node.name = \"bluez_output.38_18_4C_05_C3_B1.1\"" # WH-1000XM3
        "node.name = \"alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink\"" # Speakers plugged into motherboard
      ];
    };
  };
}
