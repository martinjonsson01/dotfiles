#
# Desktop sharing application, providing remote support and online meetings.
#
{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    teamviewer.enable = lib.mkEnableOption "Enables Teamviewer";
  };

  config = lib.mkIf config.teamviewer.enable {
    environment.systemPackages = with pkgs; [
      teamviewer
    ];

    # Enable TeamViewer Daemon
    services.teamviewer.enable = true;
  };
}
