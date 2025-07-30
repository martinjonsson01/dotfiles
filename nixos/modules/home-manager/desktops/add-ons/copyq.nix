#
# CopyQ is an advanced clipboard manager with powerful editing and scripting features.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    copyq.enable = mkEnableOption "Enables CopyQ";
  };

  config = mkIf config.copyq.enable {
    home.packages = with pkgs; [copyq];

    # Built-in copyq service is broken on wayland, need to
    # create one manually.
    services.copyq.enable = false;
    systemd.user.services.copyq = {
      Unit = {
        Description = "CopyQ clipboard management daemon";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${getExe pkgs.copyq}";
        Restart = "on-failure";
        Environment = ["QT_QPA_PLATFORM=wayland"];
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };

    # Add keybind.
    programs.niri.settings.binds = with config.lib.niri.actions;
      mkIf config.niri.enable {
        "Mod+V".action = spawn ["${getExe pkgs.copyq}" "show"];
      };

    # Make window floating.
    programs.niri.settings.window-rules = mkIf config.niri.enable [
      {
        matches = [
          {
            app-id = "^com.github.hluk.copyq$";
          }
        ];
        open-floating = true;
      }
    ];
  };
}
