#
# Mutes the mic on login.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    mic-default-mute.enable = mkEnableOption "Mutes mic on login";
  };

  config = mkIf config.mic-default-mute.enable {
    systemd.user.services.mic-default-mute = {
      Unit = {
        Description = "Mute microphone on login";
        After = ["pipewire.service"];
        Requires = ["pipewire.service"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ 1";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
