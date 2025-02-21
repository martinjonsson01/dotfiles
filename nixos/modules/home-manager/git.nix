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
        init.defaultBranch = "master";
      };
    };

    programs.lazygit = {
      enable = true;
    };
  };
}
