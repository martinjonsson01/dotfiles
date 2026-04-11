#
# Get up and running with large language models locally.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    ollama.enable = mkEnableOption "Enables Ollama";
  };

  config = mkIf config.ollama.enable {
    services.ollama = {
      enable = true;
      package = pkgs.unstable.ollama-cuda;
      acceleration = "cuda";
    };
  };
}
