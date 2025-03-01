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
      gnomeExtensions.advanced-alttab-window-switcher
      gnomeExtensions.smart-auto-move
    ];

    dconf.settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        system-monitor.extensionUuid
        workspace-indicator.extensionUuid
        tiling-shell.extensionUuid
        runcat.extensionUuid
        appindicator.extensionUuid
        pano.extensionUuid
        advanced-alttab-window-switcher.extensionUuid
        smart-auto-move.extensionUuid
      ];
    };

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
        # gtk-theme = "Adwaita"; Disabled due to gtk-theme.nix - this should maybe be broken out into its own module?

        gtk-enable-primary-paste = false;
      };

      "org/gnome/desktop/wm/preferences" = {
        action-middle-click-titlebar = "toggle-maximize-vertically";
        button-layout = "appmenu:minimize,close";
      };

      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
      "org/gnome/desktop/screensaver".lock-enabled = false;

      "org/gnome/desktop/wm/keybindings" = {
        switch-applications = ["<Super>Space"];
        switch-applications-backward = ["<Super><shift>Space"];

        switch-windows = ["<alt>Tab"];
        switch-windows-backward = ["<alt><shift>Tab"];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>period";
        command = "rofimoji --action copy";
        name = "Rofimoji";
      };

      "org/gnome/shell/keybindings" = {
        focus-active-notification = ["<Shift><Super>n"];
        show-screen-recording-ui = ["<Control>Print"];
        toggle-message-tray = ["<Super>n"];
        toggle-overview = ["<Super>d"];
        toggle-quick-settings = [];
      };

      "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
        enable-super = true;
        super-key-mode = 3;
        hot-edge-position = 0;
        switcher-popup-monitor = 3;
        switcher-popup-position = 2;
        switcher-popup-start-search = true;
        switcher-popup-timeout = 10;
        switcher-popup-tooltip-label-scale = 150;
        win-switcher-popup-start-search = true;
        win-switcher-popup-filter = 3;
        win-switcher-popup-preview-size = 296;
        win-switcher-popup-search-apps = true;
        win-switcher-popup-ws-indexes = false;
        win-switcher-single-prev-size = 224;
        win-switch-include-modals = true;
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-from = 19.0;
        night-light-schedule-to = 5.0;
      };

      "org/gnome/mutter" = {
        overlay-key = "Super";
      };

      "org/gnome/shell/extensions/tilingshell" = {
        active-screen-edges = false;
        resize-complementing-windows = false;
        enable-autotiling = true;
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

      "org/gnome/shell/extensions/smart-auto-move" = {
        activate-workspace = true;
        debug-logging = false;
        freeze-saves = false;
        ignore-position = false;
        ignore-workspace = false;
        match-threshold = 0.7;
        overrides = ''
          {}
        '';
        save-frequency = 1000;
        startup-delay = 2500;
        sync-frequency = 100;
        sync-mode = "RESTORE";
      };
    };
  };
}
