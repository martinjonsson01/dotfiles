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

    systemd.services.ydotoold = lib.mkIf config.ydotool.enable {
      description = "Ydotoold virtual input device";

      partOf = ["graphical.target"];
      requires = ["graphical.target"];
      after = ["graphical.target"];
      wantedBy = ["graphical.target"];

      serviceConfig = {
        ExecStartPre = pkgs.writeShellScript "delete-ydotool-socket" ''
          ${pkgs.coreutils}/bin/rm /tmp/.ydotool_socket || true
        '';
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        ExecStopPost = pkgs.writeShellScript "delete-ydotool-socket" ''
          ${pkgs.coreutils}/bin/rm /tmp/.ydotool_socket || true
        '';
        ExecReload = "systemctl kill --signal=HUP $MAINPID";
        KillMode = "process";
        TimeoutSec = 100;
        Restart = "on-failure";

        ProtectHome = "read-only";
        PrivateTmp = false;
      };
    };
  };
}
