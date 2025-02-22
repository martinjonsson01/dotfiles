#
# Rofi - A window switcher, application launcher and dmenu replacement
#
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    rofi.enable = lib.mkEnableOption "Enables rofi";
  };

  config = lib.mkIf config.rofi.enable {
    home.packages = with pkgs; [
      wl-clipboard # Wayland clipboard utilities
    ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi.override {
        plugins = with pkgs; [
          rofi-calc # Uses `qalc` to do natural language calculations
          rofi-emoji # Emoji selector
          rofi-top # Interactive process viewer
        ];
      };
      extraConfig = {
        modi = "calc,filebrowser,emoji,top,drun,window";
        combi-modes = "drun,window,filebrowser";

        font = "mono 20";
        show-icons = true;
        icon-theme = "Fluent-dark";

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
