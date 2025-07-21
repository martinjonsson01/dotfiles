{
  pkgs-unstable,
  lib,
  config,
  ...
}: {
  options = {
    git.enable = lib.mkEnableOption "Enables git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = "Martin";
      userEmail = "martinjonsson01@gmail.com";
      extraConfig = {
        pull = {
          rebase = true;
          ff = false;
        };
        init.defaultBranch = "master";
        rerere.enabled = true;
        column.ui = "auto";
        branch.sort = "committerdate";
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
        core = {
          excludesFile = ["~/.config/git/ignore"]; # Global .gitignore
        };
      };
    };

    xdg.configFile."git/ignore".source = ./ignore;

    programs.lazygit = {
      enable = true;
      package = pkgs-unstable.lazygit;
    };
  };
}
