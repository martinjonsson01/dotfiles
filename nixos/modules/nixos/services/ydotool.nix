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
    # https://github.com/NixOS/nixpkgs/issues/70471
    # Chown&chmod /dev/uinput to owner:root group:input mode:0660
    boot.kernelModules = ["uinput"];
    services.udev.extraRules = ''
      SUBSYSTEM=="misc", KERNEL=="uinput", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0660"
    '';

    users.users.libinput = {
      group = config.users.groups.input.name;
      description = "libinput user";
      createHome = false;
      isSystemUser = true;
      inherit (config.users.users.nobody) home;
    };

    systemd.services.ydotoold = lib.mkIf config.ydotool.enable {
      description = "Ydotoold virtual input device";

      partOf = ["graphical.target"];
      requires = ["graphical.target"];
      after = ["graphical.target"];
      wantedBy = ["graphical.target"];

      serviceConfig = {
        #ExecStartPre = pkgs.writeShellScript "delete-ydotool-socket" ''
        #  ${pkgs.coreutils}/bin/rm /tmp/.ydotool_socket || true
        #'';
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        #ExecStopPost = pkgs.writeShellScript "delete-ydotool-socket" ''
        #  ${pkgs.coreutils}/bin/rm /tmp/.ydotool_socket || true
        #'';
        ExecReload = "systemctl kill --signal=HUP $MAINPID";
        KillMode = "process";
        TimeoutSec = 100;
        Restart = "on-failure";
        User = config.users.users.libinput.name;
        Group = config.users.users.libinput.group;

        ProtectHome = "read-only";
        PrivateTmp = false;
      };
    };
  };
}
