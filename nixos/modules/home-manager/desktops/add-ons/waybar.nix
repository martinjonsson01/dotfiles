#
# Highly customizable Wayland bar for Sway and Wlroots based compositors.
#
{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with lib; let
  myHardware = osConfig.myHardware;

  leftModules =
    (
      if config.hyprland.enable
      then [
        "hyprland/workspaces"
        "hyprland/submap"
      ]
      else if config.niri.enable
      then [
        "niri/workspaces"
      ]
      else []
    )
    ++ [
      "upower#headset"
      "upower#mouse"
      "upower#controller"
    ];
  centerModules = [
    "clock"
    "custom/recording"
    "privacy"
  ];
  primaryModules = [
    "tray"
    "custom/power"
  ];
  rightModules = [
    "cpu"
    "temperature"
    "memory"
    "custom/nvidia"
    "custom/kyltermometer"
    "custom/swaync"
  ];

  createModulesCfg = isVertical: {
    clock = {
      format =
        if isVertical
        then "{:%A%n%H:%M:%S%n%F}" # Newlines between components using %n
        else "{:%A %H:%M:%S}";
      interval = 1;
      timezone = "Europe/Stockholm";

      tooltip = true;
      tooltip-format = "<tt><big>{calendar}</big></tt>";
      calendar = {
        mode = "month";
        weeks-pos = "left";
        mode-mon-col = 3;
        format = {
          months = "<span color='#ebdbb2'><b>{}</b></span>";
          days = "<span color='#a89984'><b>{}</b></span>";
          weeks = "<span color='#ebdbb2'><b>v{:%V}</b></span>";
          weekdays = "<span color='#ebdbb2'><b>{}</b></span>";
          today = "<span color='#d79921'><b>{}</b></span>";
        };
      };

      actions = {
        on-click-right = "mode";
        on-scroll-up = "shift_down";
        on-scroll-down = "shift_up";
      };
    };

    "custom/power" = {
      format = "󰤆";
      tooltip = true;
      on-click = "${pkgs.nwg-bar}/bin/nwg-bar";
    };

    # Display CPU usage.
    cpu = {
      interval = 1;
      format = let
        cores = 32;
        width =
          if isVertical
          then 8
          else cores;
        icons = map (n: "{icon${toString n}}") (range 0 (cores - 1));
        # Inserts y every n elements in xs
        insert = n: y: xs:
          if n == 0
          then xs
          else if xs == []
          then []
          else if builtins.length xs < n
          then xs
          else lists.take n xs ++ [y] ++ insert n y (lists.drop n xs);
      in
        strings.concatStrings (insert width "\n" icons);
      format-icons = [
        "<span color='#69ff94'>▁</span>" # green
        "<span color='#2aa9ff'>▂</span>" # blue
        "<span color='#f8f8f2'>▃</span>" # white
        "<span color='#f8f8f2'>▄</span>" # white
        "<span color='#ffffa5'>▅</span>" # yellow
        "<span color='#ffffa5'>▆</span>" # yellow
        "<span color='#ff9977'>▇</span>" # orange
        "<span color='#dd532e'>█</span>" # red
      ];
    };

    # CPU temperature.
    temperature = {
      critical-threshold = 75;
      format = "⚙️ {temperatureC}°C";
      hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
      on-click = "kitty btop";
    };

    # RAM usage.
    memory = {
      interval = 1;
      format = "{used:0.1f}G${
        if isVertical
        then ""
        else ""
      }/{total:0.1f}G";
    };

    # Shows GPU utilization and temperature.
    "custom/nvidia" = {
      exec = "nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,nounits,noheader | sed 's/\\([0-9]\\+\\), \\([0-9]\\+\\)/\\1% \\2°C/g'";
      format = "🖥️ {}";
      interval = 30;
    };

    # Display battery statuses.
    "upower#headset" = {
      native-path = "/org/bluez/hci0/dev_38_18_4C_05_C3_B1"; # WH-1000XM3
      format = "🎧 {percentage}";
      show-icon = false;
      hide-if-empty = true;
      tooltip = true;
      tooltip-spacing = 20;
    };
    "upower#mouse" = {
      native-path = "hidpp_battery_0"; # G603
      format = "🖱️ {percentage}";
      show-icon = false;
      hide-if-empty = true;
      tooltip = true;
      tooltip-spacing = 20;
    };
    "upower#controller" = {
      native-path = "/org/bluez/hci0/dev_40_8E_2C_A4_0A_6B"; # Xbox controller
      format = "🎮 {percentage}";
      show-icon = false;
      hide-if-empty = true;
      tooltip = true;
      tooltip-spacing = 20;
    };

    "hyprland/workspaces" = {
      format = "{name}";
      on-click = "activate";
      on-scroll-up =
        if config.hyprland.enable
        then "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch workspace e+1"
        else "";
      on-scroll-down =
        if config.hyprland.enable
        then "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch workspace e-1"
        else "";
      persistent-workspaces = {
        "1" = [];
        "2" = [];
        "3" = [];
        "4" = [];
        "5" = [];
        "6" = [];
        "7" = [];
        "8" = [];
        "9" = [];
      };
    };

    "hyprland/submap" = {
      format = "󰔡 {}";
      max-length = 100;
    };

    "niri/workspaces" = {
      format = "{}";
    };

    # Shows an icon if the screen recorder is running.
    "custom/recording" = {
      exec = "${getExe (pkgs.writers.writeBashBin "waybar-recording.sh" ''
        if pgrep -x wf-recorder > /dev/null; then
            printf '{"text": "  "}\n'
        else
            printf '{"text": ""}\n'
        fi
      '')}";
      return-type = "json";
      signal = 3;
      interval = "once";
    };

    # Shows fridge temperature.
    "custom/kyltermometer" = {
      format = "❄️ {}°C";
      exec = "${config.sops.secrets."kyltermometer".path}";
      exec-if = "exit 0";
      restart-interval = 60;
      escape = true;
    };

    # Shows if something is capturing audio/video.
    "privacy" = {
      icon-spacing = 4;
      icon-size = 36;
      transition-duration = 250;
      modules = [
        {
          type = "screenshare";
          tooltip = true;
          tooltip-icon-size = 24;
        }
        {
          type = "audio-in";
          tooltip = true;
          tooltip-icon-size = 24;
        }
      ];
      ignore-monitor = true;
      ignore = [];
    };

    # Sway notification center.
    "custom/swaync" = let
      swaync = getExe' pkgs.swaynotificationcenter "swaync-client";
    in {
      tooltip = false;
      format = "{icon}";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>";
        none = "";
        dnd-notification = "<span foreground='red'><sup></sup></span>";
        dnd-none = "";
        inhibited-notification = "<span foreground='red'><sup></sup></span>";
        inhibited-none = "";
        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
        dnd-inhibited-none = "";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "${swaync} -swb";
      on-click = "${swaync} -t -sw";
      on-click-right = "${swaync} -d -sw";
      on-click-middle = "${swaync} -C -sw";
      escape = true;
    };
  };
in {
  options = {
    waybar.enable = mkEnableOption "Enables Waybar";
  };

  config = mkIf config.waybar.enable {
    home.packages = with pkgs; [
      mosquitto # For accessing MQTT bus.
    ];

    # Script containing secrets.
    sops.secrets."kyltermometer" = {
      sopsFile = ./../../../../secrets/kyltermometer.sh;
      format = "binary";
      mode = "550";
    };

    programs.waybar = {
      enable = true;

      systemd.enable = true;

      settings =
        builtins.map (
          monitor:
            (
              if monitor.width > 5000
              then {
                position = "right";
                margin = "20 0 20 5";

                modules-left = leftModules;
                modules-center = centerModules;
                modules-right =
                  rightModules
                  ++ (
                    if monitor.primary
                    then primaryModules
                    else []
                  );
              }
              else {
                position = "bottom";
                margin = "0 20 5 20";

                modules-left = leftModules;
                modules-center = centerModules;
                modules-right =
                  rightModules
                  ++ (
                    if monitor.primary
                    then primaryModules
                    else []
                  );
              }
            )
            # Common
            // {
              output = monitor.connector;
              layer = "top";
            }
            // createModulesCfg (monitor.width > 5000)
        )
        myHardware.monitors;

      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: "${config.stylix.fonts.monospace.name}";
            font-size: ${toString config.stylix.fonts.sizes.desktop}px;
            font-weight: normal;
            padding: 1px;
        }

        button {
          min-height: 24px;
          min-width: 16px;
        }

        window#waybar {
            background-color: rgb(0, 0, 0);
            color: #C0CAF5;
            transition-property: background-color;
            transition-duration: .5s;
            border: 1px solid #C0CAF5;
            border-radius: 10px;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #workspaces button {
            color: #C0CAF5;
            padding: 0 3px;
            border-radius: 5px;
        }

        #workspaces button.focused {
            color: #7AA2F7;
        }

        #workspaces button.active {
            color: #7AA2F7;
        }

        #workspaces button.urgent {
            color: #F7768E;
        }

        #mode {
            color: #F7768E;
            padding-left: 2px;
        }

        #submap {
            color: #F7768E;
            padding-left: 2px;
        }

        #clock {
            color: #BB9AF7;
        }

        #network.down {
            color: #9ECE6A;
            padding-right: 8px;
        }

        #network.up {
            color: #7AA2F7;
            padding-right: 8px;
        }

        #tray {
            color: #C0CAF5;
            padding-right: 8px;
        }

        #custom-power {
            color: #F7768E;
            padding-right: 8px;
        }

        #custom-nvidia {
            min-width: 120px;
        }

        #custom-swaync {
            font-family: ${config.stylix.fonts.sansSerif.name};
            font-size: 20px;
        }
      '';
    };
  };
}
