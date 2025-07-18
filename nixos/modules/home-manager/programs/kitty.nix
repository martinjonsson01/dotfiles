#
# The fast, feature-rich, GPU based terminal emulator
#
{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    kitty.enable = mkEnableOption "Enables Kitty";
  };

  config = mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;

      font = {
        name = config.stylix.fonts.monospace.name;
        size = config.stylix.fonts.sizes.terminal;
      };

      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
        strip_trailing_spaces = "smart";
        tab_bar_style = "separator";
        tab_bar_align = "center";
        tab_separator = "|";
        tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{index}:{title}";
        confirm_os_window_close = 0;
        window_padding_width = "8.0";
      };

      keybindings = {
        "ctrl+c" = "copy_and_clear_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";
      };
    };
  };
}
