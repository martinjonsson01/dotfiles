#
# A helper for screenshots within Gnome
#
{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    gnome-screenshot.enable = lib.mkEnableOption "Enables gnome-screenshot";
  };

  config = lib.mkIf config.gnome-screenshot.enable {
    home.packages = with pkgs; [
      gnome-screenshot
    ];

    # Script for screenshots that get saved to dated directory + to clipboard.
    home.file."${config.xdg.configHome}/screenshot.sh" = {
      source = ./screenshot.sh;
      executable = true;
    };

    dconf.settings = {
      # Disable ordinary gnome keybinds for screenshots.
      "org/gnome/shell/keybindings" = {
        screenshot-window = [];
        screenshot = [];
        show-screenshot-ui = [];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        binding = "<Control>Print";
        command = "${config.xdg.configHome}/screenshot.sh --area";
        name = "Take screenshot of area";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        binding = "Print";
        command = "${config.xdg.configHome}/screenshot.sh";
        name = "Take screenshot of all monitors";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        binding = "<Control><Shift>Print";
        command = "${config.xdg.configHome}/screenshot.sh --window";
        name = "Take screenshot of active window";
      };
    };
  };
}
