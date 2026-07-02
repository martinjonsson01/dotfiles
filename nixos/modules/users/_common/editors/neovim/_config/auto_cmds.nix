{
  autoGroups = {
    highlight_yank = {};
    vim_enter = {};
  };

  autoCmd = [
    {
      group = "highlight_yank";
      event = ["TextYankPost"];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      };
    }
    {
      group = "vim_enter";
      event = ["VimEnter"];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.cmd('Startup')
          end
        '';
      };
    }
    {
      group = "vim_enter";
      event = ["SessionLoadPost"];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            -- Snapshot correct position now, before float window creation
            -- (fidget, incline, treesitter-context) displaces the cursor
            local buf = vim.api.nvim_get_current_buf()
            local pos = vim.api.nvim_win_get_cursor(0)
            -- Defer so all plugin float initialization can settle first
            vim.defer_fn(function()
              -- Only restore if we haven't switched buffers in the meantime
              if vim.api.nvim_get_current_buf() == buf then
                vim.api.nvim_win_set_cursor(0, pos)
              end
            end, 100)
          end
        '';
      };
    }
    {
      event = ["FileType"];
      pattern = "resc";
      command = "setlocal commentstring=#\\ %s";
    }
    {
      event = ["FileType"];
      pattern = "repl";
      command = "setlocal commentstring=//\\ %s";
    }
  ];
}
