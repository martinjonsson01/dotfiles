#
# Get up and running with large language models locally.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.ollama.enable = mkEnableOption "Enables Ollama";

  config = mkIf config.eclipse.ollama.enable {
    eclipse.hm = {pkgs, ...}: {
      services.ollama = {
        enable = true;
        package = pkgs.unstable.ollama-cuda;
        acceleration = "cuda";
      };
    };
  };
}
