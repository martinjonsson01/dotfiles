{pkgs, ...}: {
  plugins.nvim-lightbulb = {
    enable = true;

    settings = {
      autocmd.enabled = true;
      sign.enabled = false;
      virtual_text.enabled = true;
    };
  };

  extraPackages = with pkgs; [
    delta # Syntax-highlighting pager for git
  ];

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "tiny-code-action";
      version = "2025-07-29";
      doCheck = false; # The require check checks for dependencies we don't use (i.e. other pickers)
      src = pkgs.fetchFromGitHub {
        owner = "rachartier";
        repo = "tiny-code-action.nvim";
        rev = "597c4a39d5601e050d740f3ef437ee695d1ff3b0";
        hash = "sha256-+U1GUvfLPZ+4MPi7Q5LG8TJEWJHyS45qbg1dpBk7g98=";
      };
      meta.homepage = "https://github.com/rachartier/tiny-code-action.nvim";
    })
  ];

  extraConfigLua = ''
    require("tiny-code-action").setup({
    	backend = "delta",
    	picker = {
    		"buffer",
    		opts = {
    			hotkeys = true, --  Enables hotkeys for selecting actions efficiently.
    			hotkeys_mode = "text_diff_based", -- Generates smarter hotkeys based on title differences.
    			auto_preview = true, -- Automatically previews the selected action.
    			auto_accept = true, -- Automatically accepts the selected action without confirmation.
    			keymaps = {
    				close = "<ESC>",
    			},
    		},
    	},
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "ga";
      action = "<cmd>lua require('tiny-code-action').code_action()<cr>";
      options = {
        silent = true;
        desc = "Goto action (code action)";
      };
    }
  ];
}
