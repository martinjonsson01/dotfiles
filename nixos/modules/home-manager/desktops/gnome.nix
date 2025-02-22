{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    gnome.enable = lib.mkEnableOption "Enables Gnome";
  };

  config = lib.mkIf config.gnome.enable {
    home.packages = with pkgs; [
      gnome.gnome-tweaks
      gnomeExtensions.tiling-shell
      # gnomeExtensions.advanced-alttab-window-switcher
      gnomeExtensions.appindicator
      gnomeExtensions.runcat
      gnomeExtensions.super-key
      gnomeExtensions.pano
    ];

    dconf.settings = {
      # Duration of inactivity (seconds) until screen turns off.
      "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 3600;
      # Never automatically suspend.
      "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";

      "org/gnome/desktop/calendar".show-weekdate = true;
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        font-antialiasing = "rgba";
        font-hinting = "full";

        # Older GTK apps don't use the above color-scheme setting. For those set
        # the legacy theme to a dark one
        gtk-theme = "Adwaita";
        gtk-enable-primary-paste = false;
      };

      "org/gnome/desktop/wm/preferences" = {
        action-middle-click-titlebar = "toggle-maximize-vertically";
        button-layout = "appmenu:minimize,close";
      };

      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
      "org/gnome/desktop/screensaver".lock-enabled = false;

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/shell/keybindings" = {
        focus-active-notification = ["<Shift><Super>n"];
        show-screen-recording-ui = ["<Control>Print"];
        toggle-message-tray = ["<Super>n"];
        toggle-overview = ["<Super>d"];
        toggle-quick-settings = [];
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-from = 18.0;
        night-light-schedule-to = 5.0;
      };

      # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      #   binding = "Super_L";
      #   command = "rofi -show combi -calc-command \"echo -n '{result}' | wl-copy\" -calc-command-history";
      #   name = "Rofi drun";
      # };

      # Rebind overlay so that Super_L can be rebound to rofi.
      "org/gnome/mutter" = {
        overlay-key = "Super_R";
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          "tilingshell@ferrarodomenico.com"
          "runcat@kolesnikov.se"
          "appindicatorsupport@rgcjonas.gmail.com"
          "super-key@tommimon.github.com"
          "pano@elhan.io"
          # "advanced-alt-tab@G-dH.github.com"
        ];
      };

      "org/gnome/shell/extensions/pano" = {
        active-item-border-color = "rgb(236,94,94)";
        global-shortcut = ["<Super>v"];
        incognito-shortcut = ["<Shift><Super>v"];
        is-in-incognito = false;
        item-size = 200;
        link-previews = false;
        play-audio-on-copy = false;
        send-notification-on-copy = false;
        session-only-mode = true;
      };

      "org/gnome/shell/extensions/pano/code-item" = {
        body-bg-color = "rgb(154,153,150)";
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/color-item" = {
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/emoji-item" = {
        body-bg-color = "rgb(154,153,150)";
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/file-item" = {
        body-bg-color = "rgb(154,153,150)";
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/image-item" = {
        body-bg-color = "rgb(154,153,150)";
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/link-item" = {
        body-bg-color = "rgb(154,153,150)";
        header-bg-color = "rgb(26,95,180)";
        header-color = "rgb(255,255,255)";
      };

      "org/gnome/shell/extensions/pano/text-item" = {
        body-bg-color = "rgb(154,153,150)";
      };

      "org/gnome/shell/extensions/super-key" = {
        overlay-key-action = "rofi -show combi -calc-command \"echo -n '{result}' | wl-copy\" -calc-command-history";
      };

      # "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
      #   app-switcher-popup-fav-apps = false;
      #   app-switcher-popup-filter = 2;
      #   app-switcher-popup-include-show-apps-icon = false;
      #   app-switcher-popup-search-pref-running = true;
      #   enable-super = false;
      #   hot-edge-position = 0;
      #   super-double-press-action = 3;
      #   super-key-mode = 3;
      #   switcher-popup-hot-keys = false;
      #   switcher-popup-interactive-indicators = true;
      #   switcher-popup-position = 3;
      #   switcher-popup-timeout = 0;
      #   switcher-ws-thumbnails = 2;
      #   win-switcher-popup-filter = 2;
      #   win-switcher-popup-order = 1;
      # };

      "org/gnome/shell/extensions/gtktitlebar" = {
        hide-window-titlebars = "always";
        restrict-to-primary-screen = false;
      };

      "org/gnome/shell/extensions/runcat" = {
        displaying-items = "character-only";
        idle-threshold = 10;
      };

      "org/gnome/GWeather" = {
        temperature-unit = "centigrade";
      };
    };
  };
}
