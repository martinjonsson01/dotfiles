{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    git.enable = mkEnableOption "Enables git";
  };

  config = mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = "Martin";
      userEmail = "martinjonsson01@gmail.com";
      includes = [
        {
          path = "${config.home.homeDirectory}/Projects/.gitconfig";
          condition = "gitdir:${config.home.homeDirectory}/Projects/";
        }
      ];
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
      delta = {
        # Syntax-highlighting pager for git
        enable = true;
        options = {
          navigate = true;
          line-numbers = true;
          hyperlinks = true;
        };
      };
    };

    xdg.configFile."git/ignore".source = ./ignore;

    programs.lazygit = {
      enable = true;
      package = pkgs.unstable.lazygit;
      settings = {
        os = {
          editPreset = "nvim";
        };
        git = {
          paging.pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
