{pkgs-unstable, ...}: {
  plugins.fff = {
    enable = true;
    settings = {};
    package = pkgs-unstable.vimPlugins.fff-nvim;
  };
  keymaps = [
    {
      mode = "n";
      key = "<C-p>";
      action.__raw = "function() require('fff').find_files() end";
      options = {
        desc = "FFFind files";
      };
    }
    {
      mode = "n";
      key = "<leader>/";
      action.__raw = "function() require('fff').live_grep() end";
      options = {
        desc = "LiFFFe grep";
      };
    }
  ];
}
