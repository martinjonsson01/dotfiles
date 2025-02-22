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
    home.packages = with pkgs; [
      ydotool
    ];

    systemd.user.services.ydotoold = {
      Unit = {
        Description = "Autostart for ydotoold";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Install = {
        WantedBy = ["default.target"];
      };

      Service = {
        Environment = [
          "HOME=${config.home.homeDirectory}"
          "LANG=ja_JP.UTF-8"
          "LC_ALL=ja_JP.UTF-8"
        ];
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        Restart = "always";
      };
    };
  };
}
