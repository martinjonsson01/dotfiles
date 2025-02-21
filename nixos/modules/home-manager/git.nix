{
  pkgs,
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
        pull.rebase = true;
        init.defaultBranch = "master";
        rerere.enabled = true;
        column.ui = "auto";
        branch.sort = "committerdate";
      };
    };

    programs.lazygit = {
      enable = true;
    };
  };
}
