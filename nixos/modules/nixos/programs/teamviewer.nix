#
# Desktop sharing application, providing remote support and online meetings.
#
{
  pkgs,
  config,
  lib,
  ...
}: {
  options.Eclipse.teamviewer.enable = lib.mkEnableOption "Enables Teamviewer";

  config = lib.mkIf config.Eclipse.teamviewer.enable {
    environment.systemPackages = with pkgs; [
      teamviewer
    ];

    # Enable TeamViewer Daemon
    services.teamviewer.enable = true;
  };
}
