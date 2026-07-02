{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.ai;
in {
  options.eclipse.ai.enable = mkEnableOption "Enables the AI profile.";

  config = mkIf cfg.enable {
    eclipse = {
      handy.enable = mkDefault true; # Dictation
      ollama.enable = mkDefault true;
      open-webui.enable = mkDefault true;
    };

    sops.secrets."gemini-api-key" = {
      sopsFile = ./../../secrets/api.yaml;
      owner = "martin";
    };

    sops.secrets."deepseek-api-key" = {
      sopsFile = ./../../secrets/api.yaml;
      owner = "martin";
    };

    sops.secrets."openrouter-api-key" = {
      sopsFile = ./../../secrets/api.yaml;
      owner = "martin";
    };
  };
}
