{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "neotab";
      version = "e99d3e28c5a2066d2d368dfe4ef3827c8d75d337";
      src = pkgs.fetchFromGitHub {
        owner = "kawre";
        repo = "neotab.nvim";
        rev = "e99d3e28c5a2066d2d368dfe4ef3827c8d75d337";
        hash = "sha256-pSLvpKqfi1hQrFAYmXTOUOYERtnr79M23z5so2JOGhE=";
      };
      meta.homepage = "https://github.com/kawre/neotab.nvim";
    })
  ];

  extraConfigLua = ''
    require("neotab").setup({
    	smart_punctuators = {
    		enabled = true,
    		semicolon = {
    			enabled = true,
    			ft = { "cs", "c", "cpp", "java", "nix" },
    		},
    		escape = {
    			enabled = false,
    			triggers = {}, ---@type table<string, ntab.trigger>
    		},
    	},
    })
  '';
}
