#
# swaylock is a screen locking utility for Wayland compositors.
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    swaylock.enable = lib.mkEnableOption "Enables swaylock";
  };

  config = lib.mkIf config.swaylock.enable {
    programs.swaylock = {
      enable = true;

      package = pkgs.swaylock-effects;

      settings = {
        screenshots = true;
        show-failed-attempts = true;
        line-uses-inside = true;
        clock = true;
        timestr = "%I:%M%p";
        datestr = "%a, %d %b";
        indicator = true;
        effect-blur = "7x5";
        effect-compose = "50%,35%;center;${./text.png}";
        # Inside colors
        inside-color = "1A1B26";
        inside-wrong-color = "1A1B26";
        inside-ver-color = "1A1B26";
        inside-clear-color = "1A1B26";
        # Text colors
        text-color = "C0CAF5";
        text-wrong-color = "C0CAF5";
        text-ver-color = "C0CAF5";
        text-clear-color = "C0CAF5";
        text-caps-lock-color = "E0AF68";
        # Ring colors
        ring-color = "9ECE6A";
        ring-wrong-color = "F7768E";
        ring-ver-color = "7AA2F7";
        ring-clear-color = "E0AF68";
        # Highlight colors
        key-hl-color = "BB9AF7";
        bs-hl-color = "BB9AF7";
      };
    };
  };
}
