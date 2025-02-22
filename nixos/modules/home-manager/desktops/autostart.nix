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
  };
}
