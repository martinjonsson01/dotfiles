{
  lib,
  config,
  pkgs,
  ...
}: let
  mkAutostart = appDesktopNames:
    builtins.foldl' (autostartLinks: currentAppName:
      autostartLinks
      // {
        "autostart-${currentAppName}" = {
          target = ".config/autostart/${currentAppName}.desktop";
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix-profile/share/applications/${currentAppName}.desktop";
        };
      })
    {}
    appDesktopNames;
in {
  options = {
    autostart.enable = lib.mkEnableOption "Enables autostarting some apps";
  };

  config = lib.mkIf config.autostart.enable {
    home.file = mkAutostart [
      "discord"
      "slack"
      "plexamp"
    ];

    # Modify desktop entries to launch application minimized/in tray.
    xdg.desktopEntries = {
      discord = {
        name = "Discord";
        categories = ["Network" "InstantMessaging"];
        exec = "Discord --start-minimized";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        icon = "discord";
        mimeType = ["x-scheme-handler/discord"];
        type = "Application";
        settings = {
          StartupWMClass = "discord";
        };
      };

      slack = {
        name = "Slack";
        categories = ["GNOME" "GTK" "Network" "InstantMessaging"];
        exec = "${pkgs.slack}/bin/slack -s %U -u";
        genericName = "Slack Client for Linux";
        comment = "Slack Desktop";
        icon = "slack";
        mimeType = ["x-scheme-handler/slack"];
        type = "Application";
        startupNotify = true;
        settings = {
          StartupWMClass = "discord";
        };
      };
    };
  };
}
