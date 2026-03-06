{
  plugins = {
    cmp-emoji = {
      enable = true;
    };
    cmp = {
      enable = true;
      settings = {
        autoEnableSources = true;
        experimental = {
          ghost_text = false;
        };
        performance = {
          debounce = 60;
          fetchingTimeout = 200;
          maxViewEntries = 30;
        };
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        formatting = {
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
        };
        sources = [
          {name = "git";}
          {name = "nvim_lsp";}
          {name = "emoji";}
          {
            name = "buffer"; # text within current buffer
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
          {
            name = "path"; # file system paths
            keywordLength = 3;
          }
          {
            name = "luasnip"; # snippets
            keywordLength = 3;
          }
        ];

        window = {
          completion = {
            border = "solid";
          };
          documentation = {
            border = "solid";
          };
        };

        mapping = {
          "<C-j>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<C-k>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<C-e>" = "cmp.mapping.abort()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        };
      };
    };
    cmp-nvim-lsp = {
      enable = true;
    }; # lsp
    cmp-buffer = {
      enable = true;
    };
    cmp-path = {
      enable = true;
    }; # file system paths
    cmp_luasnip = {
      enable = true;
    }; # snippets
    cmp-cmdline = {
      enable = false;
    }; # autocomplete for cmdline
  };
  extraConfigLua = ''
    luasnip = require("luasnip")
    kind_icons = {
    	Text = "󰊄",
    	Method = " ",
    	Function = "󰡱 ",
    	Constructor = " ",
    	Field = " ",
    	Variable = "󱀍 ",
    	Class = " ",
    	Interface = " ",
    	Module = "󰕳 ",
    	Property = " ",
    	Unit = " ",
    	Value = " ",
    	Enum = " ",
    	Keyword = " ",
    	Snippet = " ",
    	Color = " ",
    	File = "",
    	Reference = " ",
    	Folder = " ",
    	EnumMember = " ",
    	Constant = " ",
    	Struct = " ",
    	Event = " ",
    	Operator = " ",
    	TypeParameter = " ",
    }

    local cmp = require("cmp")

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
    	sources = {
    		{ name = "buffer" },
    	},
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
    	sources = cmp.config.sources({
    		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    	}, {
    		{ name = "buffer" },
    	}),
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
    	sources = cmp.config.sources({
    		{ name = "path" },
    	}, {
    		{ name = "cmdline" },
    	}),
    })'';
}
