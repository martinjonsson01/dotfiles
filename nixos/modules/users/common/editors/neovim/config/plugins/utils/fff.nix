{
  plugins.fff = {
    enable = true;
    settings = {};
  };
  keymaps = [
    {
      mode = "n";
      key = "ff";
      action.__raw = "function() require('fff').find_files() end";
      options = {
        desc = "FFFind files";
      };
    }
    {
      mode = "n";
      key = "fg";
      action.__raw = "function() require('fff').live_grep() end";
      options = {
        desc = "LiFFFe grep";
      };
    }
    {
      mode = "n";
      key = "fz";
      action.__raw = "function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end";
      options = {
        desc = "Live fffuzy grep";
      };
    }
    {
      mode = "n";
      key = "fc";
      action.__raw = "function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end";
      options = {
        desc = "Search current word";
      };
    }
  ];
}
