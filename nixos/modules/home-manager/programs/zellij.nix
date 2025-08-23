#
# Terminal workspace with batteries included.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    zellij.enable = mkEnableOption "Enables zellij";
  };

  config = mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        scroll_buffer_size = 200000;
        ui.pane_frames.rounded_corners = true;
        copy_command = "${getExe' pkgs.wl-clipboard "wl-copy"}";
        theme = "tokyo-night-dark";
      };
      enableFishIntegration = true;
    };
  };
}
