#
# Powerful yet simple to use screenshot software.
#
{
  lib,
  config,
  ...
}: {
  options = {
    flameshot.enable = lib.mkEnableOption "Enables Flameshot";
  };

  config = lib.mkIf config.flameshot.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          uiColor = "#1435c7";
        };
      };
    };
  };
}
