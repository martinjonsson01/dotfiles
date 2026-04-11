#
# Comprehensive suite for LLMs with a user-friendly WebUI
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    openWebui.enable = mkEnableOption "Enables Open WebUI";
  };

  config = mkIf config.openWebui.enable {
    home.packages = with pkgs; [
      unstable.open-webui
      gvisor # For code execution sandboxing
    ];

    home.sessionVariables = {
      OLLAMA_BASE_URL = "http://localhost:11434";
      WEBUI_AUTH = "False";
      DATA_DIR = "${config.xdg.configHome}/open-webui";
    };
  };
}
