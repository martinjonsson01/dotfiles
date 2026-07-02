#
# Desktop sharing application, providing remote support and online meetings.
#
{
  pkgs,
  config,
  lib,
  ...
}: {
  options.eclipse.teamviewer.enable = lib.mkEnableOption "Enables Teamviewer";

  config = lib.mkIf config.eclipse.teamviewer.enable {
    environment.systemPackages = with pkgs; [
      teamviewer
    ];

    # Enable TeamViewer Daemon
    services.teamviewer.enable = true;
  };
}
