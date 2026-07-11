#
# The fast, feature-rich, GPU based terminal emulator
#
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  scrollbackPagerConfig = pkgs.writeText "kitty-scrollback.lua" ''
    local target_line = math.max(1, tonumber(vim.g.kitty_scrollback_line) or 1)
    local buffer = vim.api.nvim_get_current_buf()
    local window = vim.api.nvim_get_current_win()
    local positioned = false

    -- Terminal conversion is asynchronous, so position only after the target line exists.
    vim.api.nvim_buf_attach(buffer, false, {
      on_lines = function()
        if positioned or vim.api.nvim_buf_line_count(buffer) < target_line then
          return
        end

        positioned = true
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(buffer) or not vim.api.nvim_win_is_valid(window) then
            return
          end

          vim.api.nvim_win_set_cursor(window, { target_line, 0 })
          vim.api.nvim_win_call(window, function()
            vim.cmd("normal! zt")
          end)
        end)
        return true
      end,
    })

    vim.keymap.set("n", "q", "<Cmd>qall!<CR>", { buffer = buffer })
    -- Retain as much Kitty history as Neovim's terminal buffer permits.
    vim.bo[buffer].scrollback = 1000000
    vim.api.nvim_open_term(buffer, {})
    vim.bo[buffer].modified = false
    vim.wo[window].list = false
  '';
in {
  options.eclipse.kitty.enable = mkEnableOption "Kitty";

  config = mkIf config.eclipse.kitty.enable {
    eclipse.hm = {config, ...}: {
      programs.kitty = {
        enable = true;

        font = {
          name = config.stylix.fonts.monospace.name;
          size = config.stylix.fonts.sizes.terminal;
        };

        settings = {
          scrollback_lines = 10000;
          scrollback_pager_history_size = 32;
          scrollback_pager = escapeShellArgs [
            (getExe pkgs.unstable.neovim)
            "--clean"
            "-n"
            "--cmd"
            "set eventignore=FileType"
            "--cmd"
            "let g:kitty_scrollback_line=INPUT_LINE_NUMBER"
            "-S"
            scrollbackPagerConfig
            "-"
          ];
          enable_audio_bell = false;
          update_check_interval = 0;
          strip_trailing_spaces = "smart";
          tab_bar_style = "separator";
          tab_bar_align = "center";
          tab_separator = "|";
          tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{index}:{title}";
          confirm_os_window_close = 0;
          background_opacity = mkForce 1.0;
          background_blur = 1;
          window_padding_width = "0";
          window_padding_height = "0";
        };

        keybindings = {
          "ctrl+c" = "copy_and_clear_or_interrupt";
          "ctrl+v" = "paste_from_clipboard";
        };
      };

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/terminal" = ["kitty.desktop"];
      };

      home.shellAliases = {
        # When kitty is used to ssh into a remote that does not have its terminfo, various issues can occur. The solution is normally to copy over the terminfo. Kitty has an ssh kitten to automate exactly this.
        ssh = "kitty +kitten ssh";
      };
    };
  };
}
