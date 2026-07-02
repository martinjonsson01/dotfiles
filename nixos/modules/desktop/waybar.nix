#
# Highly customizable Wayland bar for Sway and Wlroots based compositors.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.waybar.enable = mkEnableOption "Enables Waybar";

  config = mkIf config.eclipse.waybar.enable {
    eclipse.hm = {
      config,
      osConfig,
      pkgs,
      ...
    }: let
      hardware = osConfig.eclipse.hardware;

      leftModules =
        (
          if osConfig.eclipse.niri.enable
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
        "custom/mic"
      ];
      primaryModules = [
        "tray"
        #"custom/power"
        "wireplumber"
        "custom/swaync"
      ];
      rightModules =
        [
          "cpu"
          "temperature"
          "memory"
        ]
        ++ (lib.optionals (hardware.gpuDriver == "nvidia") [
          "custom/nvidia"
        ]);

      createModulesCfg = isVertical: {
        clock = {
          format =
            if isVertical
            then "{:%A%n%H:%M:%S%n%F}" # Newlines between components using %n
            else "{:%A %H:%M:%S %F}";
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

        tray = {
          show-passive-items = true;
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
            cores = hardware.cpu.numberOfCores;
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
          hwmon-path = hardware.cpu.temperatureHwmonPath;
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

        "niri/workspaces" = {
          format = "{}";
        };

        # Shows an icon if the screen recorder is running.
        "custom/recording" = {
          exec = "${getExe (
            pkgs.writers.writeBashBin "waybar-recording.sh" ''
              if pgrep -x wf-recorder >/dev/null; then
                printf '{"text": "  "}\n'
              else
                printf '{"text": ""}\n'
              fi
            ''
          )}";
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
          ];
          ignore-monitor = true;
          ignore = [];
        };

        # To show mic mute status.
        "custom/mic" = {
          exec = ''
            print_status() {
              apps=$(${pkgs.pulseaudio}/bin/pactl list source-outputs 2>/dev/null | grep "application.process.binary" | sed 's/.*= "//;s/"//' | sort -u | tr '\n' ', ' | sed 's/,$//')
              if [ -z "$apps" ]; then
                echo '{"text": "", "class": "inactive"}'
                return
              fi
              vol=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_SOURCE@)
              if echo "$vol" | grep -q MUTED; then
                echo "{\"text\": \"󰍭\", \"class\": \"muted\", \"tooltip\": \"$apps\"}"
              else
                echo "{\"text\": \"󰍬\", \"class\": \"unmuted\", \"tooltip\": \"$apps\"}"
              fi
            }
            print_status
            ${pkgs.pulseaudio}/bin/pactl subscribe | grep --line-buffered "change" | while read -r _; do
              print_status
            done
          '';
          return-type = "json";
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
          restart-interval = 0;
        };

        # Sway notification center.
        "custom/swaync" = let
          swaync = getExe' pkgs.swaynotificationcenter "swaync-client";
        in {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
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
      home.packages = with pkgs; [
        mosquitto # For accessing MQTT bus.
      ];

      # Script containing secrets.
      sops.secrets."kyltermometer" = {
        sopsFile = ../../secrets/kyltermometer.sh;
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
                }
                else {
                  position = "bottom";
                }
              )
              # Common
              // {
                output = monitor.connector;
                layer = "top";
                margin = "0 0 0 0";

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
              // createModulesCfg (monitor.width > 5000)
          )
          hardware.monitors;

        style = ''
          * {
            font-family: "${config.stylix.fonts.monospace.name}";
            font-size: ${toString config.stylix.fonts.sizes.desktop}px;
            border-radius: 0;
            min-height: 0;
            border: none;
            font-weight: bold;
          }

          #custom-mic {
            font-size: 48px;
            color: red;
          }

          #custom-mic.muted {
            color: green;
          }

          #workspaces{
            background-color: rgba(24,24,37,1.0);
            border: none;
            box-shadow: none;
          }

          #tray{
            margin: 6px 3px;
            background-color: rgba(36, 36, 52, 1.0);
            padding: 6px 12px;
            border-radius: 6px;
            border-width: 0px;
          }

          #waybar {
            background-color: #181825;
            transition-property: background-color;
            transition-duration: 0.5s;
          }

          #window,
          #clock,
          #custom-power,
          #custom-reboot,
          #bluetooth,
          #battery,
          #pulseaudio,
          #backlight,
          #temperature,
          #upower,
          #memory,
          #cpu,
          #network,
          #custom-kyltermometer,
          #custom-nvidia,
          #custom-lock{
            border-radius: 4px;
            margin: 6px 3px;
            padding: 0 12px;
            background-color: #1e1e2e;
            color: #181825;
          }

          #clock {
            background-color: #89b4fa;
          }
          #custom-power{
            background-color: #f38ba8;
          }
          #custom-nvidia{
            background-color: #a6e3a1;
          }
          #upower{
            background-color: #ca9ee6;
          }
          #battery{
            background-color: #cba6f7;
          }
          #pulseaudio{
            background-color: #89dceb;
          }
          #backlight{
            background-color: #a6a3a1;
          }
          #temperature{
            background-color: #74c7ec;
          }
          #memory{
            background-color: #f7768e;
          }
          #cpu{
            background-color: rgba(36, 36, 52, 1.0);
          }
          #custom-kyltermometer{
            background-color: #fab387;
          }
          #custom-lock{
            background-color: #94e2d5;
          }
          #window{
            background-color: #74c7ec;
          }

          #custom-swaync {
              font-family: ${config.stylix.fonts.sansSerif.name};
              font-size: 20px;
          }
          #custom-recording {
              color:rgb(255, 52, 48);
              font-size: 40px;
          }
          #custom-nvidia {
              min-width: 120px;
          }


          #waybar.hidden {
            opacity: 0.5;
          }

          #workspaces button {
            all: initial;
            /* Remove GTK theme values (waybar #1351) */
            min-width: 0;
            /* Fix weird spacing in materia (waybar #450) */
            box-shadow: inset 0 -3px transparent;
            /* Use box-shadow instead of border so the text isn't offset */
            padding: 6px 18px;
            margin: 6px 3px;
            border-radius: 4px;
            background-color: rgba(36, 36, 52, 1.0);
            color: #cdd6f4;
          }

          #workspaces button.active {
            color: #1e1e2e;
            background-color: #cdd6f4;
          }

          #workspaces button:hover {
            box-shadow: inherit;
            text-shadow: inherit;
            color: #1e1e2e;
            background-color: #cdd6f4;
          }

          tooltip {
            border-radius: 8px;
            padding: 16px;
            background-color: #131822;
            color: #C0C0C0;
          }

          tooltip label {
            padding: 5px;
            background-color: #131822;
            color: #C0C0C0;
          }
        '';
      };
    };
  };
}
