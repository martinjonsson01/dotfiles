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
      gnomeExtensions.dash-to-panel
      gnomeExtensions.another-window-session-manager
    ];

    dconf.settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        system-monitor.extensionUuid
        tiling-shell.extensionUuid
        runcat.extensionUuid
        appindicator.extensionUuid
        pano.extensionUuid
        advanced-alttab-window-switcher.extensionUuid
        dash-to-panel.extensionUuid
        another-window-session-manager.extensionUuid
      ];
    };

    dconf.settings = {
      # Duration of inactivity (seconds) until screen turns off.
      "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 3600;

      "org/gnome/settings-daemon/plugins/power" = {
        # Never automatically suspend.
        sleep-inactive-ac-type = "nothing";
        # Use hibernate instead of suspend.
        sleep-inactive-battery-type = "hibernate";
      };

      "org/gnome/desktop/calendar".show-weekdate = true;
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        font-antialiasing = "rgba";
        font-hinting = "full";

        enable-hot-corners = false; # Disable moving mouse into corner stuff

        # Older GTK apps don't use the above color-scheme setting. For those set
        # the legacy theme to a dark one
        # gtk-theme = "Adwaita"; Disabled due to gtk-theme.nix - this should maybe be broken out into its own module?

        gtk-enable-primary-paste = false;
      };

      "org/gnome/TextEditor" = {
        use-system-font = false;
        custom-font = "${config.stylix.fonts.monospace.name} ${toString config.stylix.fonts.sizes.applications}";
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
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>period";
        command = "rofimoji --action copy";
        name = "Rofimoji";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>e";
        command = "${pkgs.nautilus}/bin/nautilus --new-window";
        name = "Nautilus File Explorer";
      };

      "org/gnome/shell/keybindings" = {
        focus-active-notification = ["<Shift><Super>n"];
        show-screen-recording-ui = ["<Control>Print"];
        toggle-message-tray = ["<Super>n"];
        toggle-overview = ["<Super>d"];
        toggle-quick-settings = [];
      };

      "org/gnome/shell/extensions/system-monitor" = {
        show-download = false;
        show-upload = false;
      };

      "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
        enable-super = true;
        super-key-mode = 2;
        hot-edge-position = 0;
        switcher-popup-monitor = 3;
        switcher-popup-position = 2;
        switcher-popup-start-search = true;
        switcher-popup-timeout = 0;
        switcher-popup-tooltip-label-scale = 150;
        switcher-ws-thumbnails = 1;
        switcher-popup-preview-selected = 2;
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
        night-light-schedule-from = 19.5; # It seems to trigger half an hour early, idk why
        night-light-schedule-to = 5.0;
      };

      "org/gnome/mutter" = {
        overlay-key = "Super";
      };

      "org/gnome/shell/extensions/tilingshell" = {
        active-screen-edges = false;

        resize-complementing-windows = true;

        restore-window-original-size = false;

        layouts-json = builtins.readFile ./tiling-shell-layouts.json;
        selected-layouts = import ./tiling-shell-selected-layouts.nix;
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

      "org/gnome/shell/extensions/another-window-session-manager" = {
      };

      "org/gnome/shell/extensions/dash-to-panel" = {
        panel-sizes = "{\"0\": 48,\"1\": 48,\"2\": 64}";

        panel-positions-monitors-sync = false;
        panel-positions = "{\"2\":\"RIGHT\"}";

        appicon-margin = 4;
        appicon-padding = 8;

        window-preview-size = 360;

        show-window-previews-timeout = 100;
        leave-timeout = 10;
        window-preview-animation-time = 100;
        window-preview-hide-immediate-click = true;
        enter-peek-mode-timeout = 200;

        isolate-workspaces = true; # Only show apps in taskbar that are on this workspace
        isolate-monitors = true; # Only show apps in taskbar that are on this monitor

        hide-overview-on-startup = true;

        stockgs-panelbtn-click-only = true; # Activate panel menu buttons on click only (no hover)
      };
    };
  };
}
