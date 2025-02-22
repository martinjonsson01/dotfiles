#
# A rofi frontend for Bitwarden
#
{
  pkgs,
  lib,
  config,
  ...
}: let
  # Configuration options for rofi-rbw
  rofiRbwConfig = {
    action = ["type"]; # default, copy, print
    target = ["username" "password"]; # Can include "notes", "totp", or any custom field
    prompt = ["Bitwarden"]; # Custom prompt text
    clear-after = ["15"]; # Clear the clipboard after 15 seconds
    # keybindings = ["Alt+1:type:username:enter:delay:password:enter"]; # Custom keybindings
    typer = ["${pkgs.dotool}"]; # Type the characters using this application
  };

  # Convert the configuration to a format suitable for the rofi-rbw.rc file
  configText =
    lib.concatStringsSep
    "\n"
    (
      lib.mapAttrsToList
      (name: value: "${name}=${lib.concatStringsSep "," value}")
      rofiRbwConfig
    );
in {
  options = {
    rofi-rbw.enable = lib.mkEnableOption "Enables rofi-rbw";
  };

  config = lib.mkIf config.rofi-rbw.enable {
    home.packages = with pkgs; [
      rbw
      rofi-rbw-wayland
      xdotool
      wtype
      dotool
      wl-clipboard
    ];

    # Write the rofi-rbw configuration file
    home.file.".config/rofi-rbw.rc".text = configText;
  };
}
