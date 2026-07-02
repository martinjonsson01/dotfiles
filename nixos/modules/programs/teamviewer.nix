#
# Desktop sharing application, providing remote support and online meetings.
#
{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.teamviewer.enable = mkEnableOption "Enables Teamviewer";

  config = mkIf config.eclipse.teamviewer.enable {
    environment.systemPackages = with pkgs; [
      teamviewer
    ];

    # Enable TeamViewer Daemon
    services.teamviewer.enable = true;
  };
}
