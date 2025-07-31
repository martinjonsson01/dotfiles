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
  };
}
