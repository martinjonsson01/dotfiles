#
# Offline speech-to-text with push-to-talk via whisper.cpp.
# Uses the official Handy flake (github:cjpais/Handy).
#
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  options.eclipse.handy.enable = mkEnableOption "Enables Handy speech-to-text";

  config = mkIf config.eclipse.handy.enable {
    programs.handy = {
      enable = true;
      package = inputs.handy.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    eclipse.hm = {
      pkgs,
      osConfig,
      inputs,
      ...
    }: let
      handy-pkg = inputs.handy.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in {
      imports = [
        inputs.handy.homeManagerModules.default
      ];

      services.handy = {
        enable = true;
        package = handy-pkg;
      };

      home.packages = with pkgs; [
        ydotool # Needed for Handy's built-in clipboard paste (Ctrl+V simulation)
      ];

      # Handy's built-in clipboard paste needs these
      systemd.user.services.handy.Service.Environment = [
        "YDOTOOL_SOCKET=/run/ydotoold/socket"
      ];

      programs.niri.settings = mkIf osConfig.eclipse.niri.enable {
        spawn-at-startup = [
          {command = ["${handy-pkg}/bin/handy"];}
        ];

        binds = {
          "Ctrl+Shift+Alt+C".action = {
            spawn = [
              "${handy-pkg}/bin/handy"
              "--toggle-transcription"
            ];
          };
        };
      };
    };
  };
}
