{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  myHardware = osConfig.myHardware;
in {
  settings =
    {
      # Ask the applications to omit their client-side decorations.
      prefer-no-csd = true;

      # Where screenshots are saved. Format is e.g. 2025/jun/06-10:53:34.png
      screenshot-path = "~/Pictures/Screenshots/%Y/%m/%b/%d-%H:%M:%S.png";

      environment = {
        DISPLAY = ":0";
        QT_QPA_PLATFORM = "wayland";
      };

      # Speed up animations.
      animations.slowdown = 0.5;

      # Disable startup help view.
      hotkey-overlay.skip-at-startup = true;

      # Disable middle mouse paste.
      clipboard.disable-primary = true;

      # Workaround to fix screen share flickering (https://github.com/YaLTeR/niri/issues/1955)
      debug.wait-for-frame-completion-in-pipewire = {};
    }
    // (import ./input.nix)
    // (import ./outputs.nix {inherit lib myHardware;})
    // (import ./spawn-at-startup.nix {inherit pkgs lib myHardware;})
    // (import ./layout.nix)
    // (import ./window-rules.nix {inherit config;})
    // (import ./layer-rules.nix)
    // (import ./binds.nix {inherit pkgs lib config;})
    // (import ./workspaces.nix {inherit myHardware;});
}
