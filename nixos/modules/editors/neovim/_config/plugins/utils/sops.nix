{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "sops.nvim";
      version = "2025-07-23";
      src = pkgs.fetchFromGitHub {
        owner = "trixnz";
        repo = "sops.nvim";
        rev = "07fcf60a66b8b65861eb5012241300bc83d944ae";
        hash = "sha256-vf9yTz0u0NUz9gdz9ZOIwnwo0tawbj8xXC+TuMznmhs=";
      };
      meta.homepage = "https://github.com/trixnz/sops.nvim/";
      meta.hydraPlatforms = [];
    })
  ];

  extraConfigLua = ''
    require('sops').setup()
  '';
}
