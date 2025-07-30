#
# CopyQ is an advanced clipboard manager with powerful editing and scripting features.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    copyq.enable = mkEnableOption "Enables CopyQ";
  };

  config = mkIf config.copyq.enable {
    services.copyq.enable = true;

    programs.niri.settings.binds = with config.lib.niri.actions;
      mkIf config.niri.enable {
        "Mod+V".action = spawn "${getExe pkgs.copyq} show";
      };
  };
}
