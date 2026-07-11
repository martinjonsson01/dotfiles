#
# Comprehensive suite for LLMs with a user-friendly WebUI
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.open-webui.enable = mkEnableOption "Open WebUI";

  config = mkIf config.eclipse.open-webui.enable {
    eclipse.hm = {
      pkgs,
      config,
      ...
    }: {
      home.packages = with pkgs; [
        unstable.open-webui
      ];

      systemd.user.services.open-webui = {
        Unit = {
          Description = "Open WebUI";
          After = [
            "network.target"
            "ollama.service"
          ];
        };
        Service = {
          ExecStart = "${pkgs.unstable.open-webui}/bin/open-webui serve --port 38712";
          Restart = "on-failure";
          Environment = [
            "OLLAMA_BASE_URL=http://localhost:11434"
            "WEBUI_AUTH=False"
            "DATA_DIR=${config.xdg.configHome}/open-webui"
          ];
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
