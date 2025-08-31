{pkgs, ...}: {
  plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight.enable = true;
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<C-Space>";
          node_incremental = "<C-Space>";
          scope_incremental = "<C-S-Space>";
          node_decremental = "<C-B>";
        };
      };
    };
    folding = false;
    nixvimInjections = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };

  plugins.treesitter-textobjects = {
    enable = true;
    select = {
      enable = true;
      lookahead = true;
      keymaps = {
        ab = {
          query = "@block.outer";
          desc = "around block";
        };
        ib = {
          query = "@block.inner";
          desc = "inside block";
        };
        aa = {
          query = "@parameter.outer";
          desc = "around parameter";
        };
        ia = {
          query = "@parameter.inner";
          desc = "inside parameter";
        };
        af = {
          query = "@function.outer";
          desc = "around function";
        };
        "if" = {
          query = "@function.inner";
          desc = "inside function";
        };
        ac = {
          query = "@class.outer";
          desc = "around class";
        };
        ic = {
          query = "@class.inner";
          desc = "inside class";
        };
        ai = {
          query = "@conditional.outer";
          desc = "around conditional";
        };
        ii = {
          query = "@conditional.inner";
          desc = "inside conditional";
        };
        al = {
          query = "@loop.outer";
          desc = "around loop";
        };
        il = {
          query = "@loop.inner";
          desc = "inside loop";
        };
        at = {
          query = "@comment.outer";
          desc = "around comment";
        };
        it = {
          query = "@comment.inner";
          desc = "inside comment";
        };
      };
    };
    move = {
      enable = true;
      gotoNextStart = {
        "]m" = "@function.outer";
        "]]" = "@class.outer";
      };
      gotoNextEnd = {
        "]M" = "@function.outer";
        "][" = "@class.outer";
      };
      gotoPreviousStart = {
        "[m" = "@function.outer";
        "[[" = "@class.outer";
      };
      gotoPreviousEnd = {
        "[M" = "@function.outer";
        "[]" = "@class.outer";
      };
    };
    swap = {
      enable = true;
      swapNext = {
        "<leader>a" = "@parameters.inner";
      };
      swapPrevious = {
        "<leader>A" = "@parameter.outer";
      };
    };
  };
}
