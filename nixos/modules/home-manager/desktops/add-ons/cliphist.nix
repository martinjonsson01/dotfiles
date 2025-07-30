#
# Wayland clipboard manager.
#
{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    cliphist.enable = mkEnableOption "Enables Cliphist";
  };

  config = mkIf config.cliphist.enable {
    services.cliphist.enable = true;
  };
}
