#
# Generic Linux command-line automation tool (no X!)
#
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    ydotool.enable = lib.mkEnableOption "Enables ydotool";
  };

  config = lib.mkIf config.ydotool.enable {
    environment.systemPackages = with pkgs; [
      ydotool
    ];

    systemd.services.ydotoold = {
      enable = true;
      description = "RIP Mouse, thou shalt be missed";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
