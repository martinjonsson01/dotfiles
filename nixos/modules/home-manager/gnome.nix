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
      gnomeExtensions.advanced-alttab-window-switcher
      gnomeExtensions.appindicator
      gnomeExtensions.runcat
    ];

    dconf.settings = {
      # Duration of inactivity (seconds) until screen turns off.
      "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 3600;
      # Never automatically suspend.
      "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";

      "org/gnome/desktop/calendar".show-weekdate = true;
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        font-antialiasing = "grayscale";
        font-hinting = "slight";

        # Older GTK apps don't use the above color-scheme setting. For those set
        # the legacy theme to a dark one
        gtk-theme = "Adwaita-dark";
      };

      "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
        app-switcher-popup-fav-apps = false;
        app-switcher-popup-filter = 2;
        app-switcher-popup-include-show-apps-icon = false;
        app-switcher-popup-search-pref-running = true;
        enable-super = false;
        hot-edge-position = 0;
        super-double-press-action = 3;
        super-key-mode = 3;
        switcher-popup-hot-keys = false;
        switcher-popup-interactive-indicators = true;
        switcher-popup-position = 3;
        switcher-popup-timeout = 0;
        switcher-ws-thumbnails = 2;
        win-switcher-popup-filter = 2;
        win-switcher-popup-order = 1;
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
