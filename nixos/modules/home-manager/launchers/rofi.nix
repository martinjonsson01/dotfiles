#
# Rofi - A window switcher, application launcher and dmenu replacement
#
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkForce;
  inherit (config.lib.formats.rasi) mkLiteral;
  inherit (config.lib.stylix.colors.withHashtag) base00 base05;

  # Configuration options for rofi-rbw
  rofiRbwConfig = {
    action = ["type"]; # default, copy, print
    target = ["username" "password"]; # Can include "notes", "totp", or any custom field
    prompt = ["Bitwarden"]; # Custom prompt text
    clear-after = ["15"]; # Clear the clipboard after 15 seconds
    # keybindings = ["Alt+1:type:username:enter:delay:password:enter"]; # Custom keybindings
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
    rofi.enable = lib.mkEnableOption "Enables rofi";
  };

  config = lib.mkIf config.rofi.enable {
    home.packages = with pkgs; [
      wl-clipboard # Wayland clipboard utilities
      wtype # xdotool type for wayland
    ];

    # Write the rofi-rbw configuration file
    home.file.".config/rofi-rbw.rc".text = configText;

    programs.rofi = {
      enable = true;
      package = pkgs.rofi.override {
        plugins = with pkgs; [
          rofi-calc # Uses `qalc` to do natural language calculations
          rofi-emoji # Emoji selector
          rofi-rbw # Bitwarden plugin
          rofi-top # Interactive process viewer
        ];
      };
      extraConfig = {
        modi = "drun,window,filebrowser,emoji,calc,top";
        combi-modes = "drun,filebrowser";

        font = "mono 20";
        show-icons = true;
        icon-theme = "Fluent-dark";

        auto-select = true; # Auto select when only one thing matches

        # Hide "run ... / window ..." prefixes
        display-drun = "";
        display-window = "";
        display-combi = "";

        drun-match-fields = "name,generic,categories";
        drun-show-actions = true;

        matching = "fuzzy";

        window-thumbnail = true;

        sort = true;
        sorting-method = "fzf";
      };

      theme = "${pkgs.fetchurl {
        url = "https://github.com/undiabler/nord-rofi-theme/raw/eebddcbf36052e140a9af7c86f1fbd88e31d2365/nord.rasi";
        sha256 = "sha256-3P7Fpsev0Y7oBtK+x2R4V4aCkdQThybUSySufNFGtl4=";
      }}";
    };
  };
}
