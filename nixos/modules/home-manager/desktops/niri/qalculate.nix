#
# Ultimate desktop calculator.
#
{
  pkgs,
  lib,
  ...
}:
with lib; {
  programs.niri.settings = {
    binds."Mod+Space".action.spawn = "${getExe pkgs.qalculate-gtk}";
    window-rules = [
      {
        matches = [{app-id = "qalculate-gtk";}];
        open-floating = true;
      }
    ];
  };
}
