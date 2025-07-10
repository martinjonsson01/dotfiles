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
        pull.rebase = true;
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
        advice.diverging = false; # For some reason this warning pops up even though pull.rebase = true
      };
    };

    programs.lazygit = {
      enable = true;
      package = pkgs-unstable.lazygit;
    };
  };
}
