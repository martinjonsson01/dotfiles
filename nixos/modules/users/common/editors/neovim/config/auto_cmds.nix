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
