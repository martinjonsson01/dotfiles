#
# Powerful yet simple to use screenshot software.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    flameshot.enable = mkEnableOption "Enables Flameshot";
  };

  config = mkIf config.flameshot.enable {
    home.packages = with pkgs; [
      (flameshot.override
        {
          enableWlrSupport = true;
        })
    ];

    programs.niri.settings.window-rules = mkIf config.niri.enable [
      {
        matches = [
          {
            app-id = "^flameshot$";
          }
        ];
        open-floating = true;
      }
    ];
  };
}
