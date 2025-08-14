{
  colorschemes = {
    catppuccin = {
      enable = false;
      settings = {
        custom_highlights = ''
          function(highlights)
            return {
            CursorLineNr = { fg = highlights.peach, style = {} },
            NavicText = { fg = highlights.text },
            }
          end
        '';
        # Setting this breaks nvim-web-devicons for some reason ?? flavour = "macchiato"; # "latte", "mocha", "frappe", "macchiato" or raw lua code
        integrations = {
          cmp = true;
          notify = true;
          gitsigns = true;
          neotree = true;
          which_key = true;
          illuminate = {
            enabled = true;
            lsp = true;
          };
          navic = {
            enabled = true;
            custom_bg = "NONE";
          };
          treesitter = true;
          telescope.enabled = true;
          indent_blankline.enabled = true;
          mini = {
            enabled = true;
          };
          native_lsp = {
            enabled = true;
            inlay_hints = {
              background = true;
            };
            virtual_text = {
              errors = ["italic"];
              hints = ["italic"];
              information = ["italic"];
              warnings = ["italic"];
              ok = ["italic"];
            };
            underlines = {
              errors = ["undercurl"];
              hints = ["undercurl"];
              information = ["undercurl"];
              warnings = ["undercurl"];
            };
          };
        };
      };
    };

    tokyonight = {
      enable = true;

      settings = {
        style = "night";
        styles = {
          floats = "dark";
          sidebars = "dark";
          comments.italic = true;
          keywords = {
            bold = true;
          };
        };
        on_highlights =
          #lua
          ''
            function(highlights, colors)
              highlights.TreesitterContext = highlights.NormalFloat;
            end
          '';
      };
    };
  };

  # Workaround necessary to enable theme late
  extraConfigLuaPost = ''
    vim.cmd("colorscheme tokyonight")
  '';
}
