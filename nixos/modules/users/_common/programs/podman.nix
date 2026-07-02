#
# Program for managing pods, containers and container images.
#
{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    podman.enable = mkEnableOption "Enables podman";
  };

  config = mkIf config.podman.enable {
    services.podman = {
      enable = true;
    };
  };
}
