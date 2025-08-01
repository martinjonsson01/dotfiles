#
# Generic Linux command-line automation tool.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  ydotool = pkgs.ydotool;
  socket = "/run/ydotoold/socket";
in {
  options = {
    ydotool.enable = mkEnableOption "Enables ydotool";
  };

  config = mkIf config.ydotool.enable {
    environment.variables.YDOTOOL_SOCKET = socket;
    environment.sessionVariables.YDOTOOL_SOCKET = socket;

    users.groups.ydotool = {};
    users.users.martin.extraGroups = ["ydotool"];

    environment.systemPackages = [ydotool];
    systemd.services.ydotoold = {
      wantedBy = ["multi-user.target"];
      partOf = ["multi-user.target"];
      serviceConfig = {
        Group = "ydotool";
        RuntimeDirectory = "ydotoold";
        RuntimeDirectoryMode = "0750";
        ExecStart = "${getExe' ydotool "ydotoold"} --socket-path=${socket} --socket-perm=0660";
        # hardening
        ## allow access to uinput
        DeviceAllow = ["/dev/uinput"];
        DevicePolicy = "closed";
        ## allow creation of unix sockets
        RestrictAddressFamilies = ["AF_UNIX"];
        CapabilityBoundingSet = "";
        IPAddressDeny = "any";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
        # -> systemd-analyze security score 0.7 SAFE
      };
    };
  };
}
