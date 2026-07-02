#
# Program for managing pods, containers and container images.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.podman.enable = mkEnableOption "Enables podman";

  config = mkIf config.eclipse.podman.enable {
    eclipse.hm = {
      services.podman = {
        enable = true;
      };
    };
  };
}
