#
# Real-time microphone noise suppression.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    noisetorch.enable = mkEnableOption "Enables NoiseTorch";
  };

  config = mkIf config.noisetorch.enable {
    systemd.user.services.noisetorch = {
      Unit = {
        Description = "NoiseTorch noise suppression";
        After = ["pipewire.service"];
        Requires = ["pipewire.service"];
      };
      Service = {
        Type = "simple";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.noisetorch}/bin/noisetorch -i -s $(${pkgs.pulseaudio}/bin/pactl get-default-source) -t 30'";
        ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };

    systemd.user.services.noisetorch-resume = {
      Unit = {
        Description = "Restart NoiseTorch after suspend";
        After = ["suspend.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl --user restart noisetorch";
      };
      Install = {
        WantedBy = ["suspend.target"];
      };
    };
  };
}
