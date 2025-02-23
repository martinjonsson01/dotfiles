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
          # rofi-emoji # Emoji selector
          rofi-top # Interactive process viewer
        ];
      };
      extraConfig = {
        modi = "calc,filebrowser,top,drun,window";
        combi-modes = "window,drun,filebrowser";

        font = "${config.stylix.fonts.monospace.name} ${toString config.stylix.fonts.sizes.popups}";
        show-icons = true;
        icon-theme = "Fluent-dark";

        drun-match-fields = "name,generic,categories";
        drun-show-actions = true;

        matching = "fuzzy";

        window-thumbnail = true;

        sort = true;
        sorting-method = "fzf";

        kb-cancel = "Escape,MouseMiddle";

        kb-select-1 = "Ctrl+1";
        kb-select-2 = "Ctrl+2";
        kb-select-3 = "Ctrl+3";
        kb-select-4 = "Ctrl+4";
        kb-select-5 = "Ctrl+5";
        kb-select-6 = "Ctrl+6";
        kb-select-7 = "Ctrl+7";
        kb-select-8 = "Ctrl+8";
        kb-select-9 = "Ctrl+9";
        kb-select-10 = "Ctrl+0";
      };

      theme = "${pkgs.fetchurl {
        url = "https://github.com/undiabler/nord-rofi-theme/raw/eebddcbf36052e140a9af7c86f1fbd88e31d2365/nord.rasi";
        sha256 = "sha256-3P7Fpsev0Y7oBtK+x2R4V4aCkdQThybUSySufNFGtl4=";
      }}";
    };
  };
}
