#
# The nwg-bar command creates a button bar on the basis of a JSON template.
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    nwg-bar.enable = lib.mkEnableOption "Enables nwg-bar";
  };

  config = lib.mkIf config.nwg-bar.enable {
    swaylock.enable = true;

    home.packages = [pkgs.nwg-bar];

    xdg.configFile = {
      "nwg-bar/bar.json".text = ''
        [
          {
            "label": "_Lock",
            "exec": "${config.programs.swaylock.package}/bin/swaylock",
            "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-lock-screen.svg"
          },
          {
            "label": "_Exit",
            "exec": "${
          if config.wayland.windowManager.sway.enable
          then "swaymsg exit"
          else if config.wayland.windowManager.hyprland.enable
          then "hyprctl dispatch exit"
          else ""
        }",
            "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-log-out.svg"
          },
          {
            "label": "_Reboot",
            "exec": "systemctl reboot",
            "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-reboot.svg"
          },
          {
            "label": "_Shutdown",
            "exec": "systemctl -i poweroff",
            "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-shutdown.svg"
          },
          {
            "label": "UE_FI",
            "exec": "systemctl reboot --firmware-setup",
            "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-reboot.svg"
          }
        ]
      '';

      "nwg-bar/style.css".text = ''
        window {
          border: 1px solid #C0CAF5;
          border-radius: 10px;
          background-color: #1A1B26;
        }
        button, image {
          color: #C0CAF5;
          background: none;
          border: none;
          box-shadow: none;
        }
        button {
          padding-left: 10px;
          padding-right: 10px;
          margin: 5px;
        }
        button:hover {
          background-color: #16161E
        }
      '';
    };
  };
}
