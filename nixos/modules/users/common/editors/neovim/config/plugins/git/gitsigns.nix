{
  lib,
  config,
  ...
}:
with lib; {
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = true;
    };
  };

  keymaps = mkIf config.plugins.gitsigns.enable [
    {
      mode = "n";
      key = "g,";
      action = "<cmd>Gitsigns nav_hunk prev<CR>";
      options = {
        desc = "Go to previous hunk";
      };
    }
    {
      mode = "n";
      key = "g.";
      action = "<cmd>Gitsigns nav_hunk next<CR>";
      options = {
        desc = "Go to next hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>grb";
      action = "<cmd>Gitsigns reset_buffer<CR>";
      options = {
        desc = "Git reset buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Gitsigns blame_line { full=true }<CR>";
      options = {
        desc = "Git blame full line";
      };
    }
    {
      mode = "n";
      key = "<leader>gtb";
      action = "<cmd>Gitsigns blame<CR>";
      options = {
        desc = "Git toggle blame for entire file";
      };
    }
    {
      mode = "n";
      key = "<leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options = {
        desc = "Git hunk stage/unstage";
      };
    }
    {
      mode = "n";
      key = "<leader>ghr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options = {
        desc = "Git hunk reset";
      };
    }
    {
      mode = "n";
      key = "<leader>ghp";
      action = "<cmd>Gitsigns preview_hunk_inline<CR>";
      options = {
        desc = "Git hunk preview inline";
      };
    }
  ];
}
