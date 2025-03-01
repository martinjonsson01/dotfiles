{
  lib,
  config,
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
        categories = ["Network" "InstantMessaging"];
        exec = "Discord --start-minimized";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        icon = "discord";
        mimeType = ["x-scheme-handler/discord"];
        name = "Discord";
        type = "Application";
        settings = {
          StartupWMClass = "discord";
        };
      };
    };
  };
}
