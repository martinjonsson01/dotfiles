#
# File manager for GNOME
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    nautilus.enable = mkEnableOption "Enables Nautilus";
  };

  config = mkIf config.nautilus.enable {
    environment.systemPackages = with pkgs; [
      nautilus
      sushi # For thumbnails in nautilus
    ];

    # Needed for trash to work in nautilus.
    services.gvfs.enable = true;

    # Set default application for opening directories.
    xdg.mime.defaultApplications."inode/directory" = "nautilus.desktop";

    # Add terminal option to right click menu.
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };
}
