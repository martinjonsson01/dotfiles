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

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>period";
        command = "rofimoji --action copy --clipboarder wl-copy";
        name = "Rofimoji";
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

      "org/gnome/mutter" = {
        overlay-key = "Super_L";
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
        ];
      };

      "org/gnome/shell/extensions/pano" = {
        active-item-border-color = "rgb(236,94,94)";
        global-shortcut = ["<Super>v"];
        incognito-shortcut = ["<Shift><Super>v"];
        is-in-incognito = false;
        item-size = 200;
        link-previews = true;
        play-audio-on-copy = false;
        send-notification-on-copy = false;
        session-only-mode = true;
        history-length = 100;
      };

      "org/gnome/shell/extensions/pano/code-item" = {
        body-bg-color = "rgb(33, 33, 33)";
        body-color = "rgb(234, 234, 234)";
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/color-item" = {
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/emoji-item" = {
        body-bg-color = "rgb(33, 33, 33)";
        body-color = "rgb(234, 234, 234)";
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/file-item" = {
        body-bg-color = "rgb(33, 33, 33)";
        body-color = "rgb(234, 234, 234)";
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/image-item" = {
        body-bg-color = "rgb(33, 33, 33)";
        body-color = "rgb(234, 234, 234)";
        header-bg-color = "rgb(26,95,180)";
      };

      "org/gnome/shell/extensions/pano/link-item" = {
        body-bg-color = "rgb(33, 33, 33)";
        header-bg-color = "rgb(26,95,180)";
        header-color = "rgb(255,255,255)";
      };

      "org/gnome/shell/extensions/pano/text-item" = {
        body-bg-color = "rgb(33, 33, 33)";
        body-color = "rgb(234, 234, 234)";
      };

      "org/gnome/shell/extensions/super-key" = {
        overlay-key-action = "rofi -show combi -calc-command \"echo -n '{result}' | wl-copy\" -calc-command-history";
      };

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
