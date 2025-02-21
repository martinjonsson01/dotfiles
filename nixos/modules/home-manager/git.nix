{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Martin";
    userEmail = "martinjonsson01@gmail.com";
    extraConfig = {
      init.defaultBranch = "master";
    };
  };
}
