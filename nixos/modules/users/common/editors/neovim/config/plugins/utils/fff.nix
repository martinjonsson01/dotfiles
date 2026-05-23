{pkgs-unstable, ...}: {
  plugins.fff = {
    enable = true;
    settings = {
      # Do not index the entire cwd on startup. This is especially dangerous
      # when Neovim is launched from $HOME for a one-off file.
      lazy_sync = true;
      max_threads = 4;
      logging.enabled = false;
    };
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
