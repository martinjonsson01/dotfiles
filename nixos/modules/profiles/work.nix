{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.work;
in {
  options.eclipse.work = {
    enable = mkEnableOption "the work profile";
    directory = mkOption {
      description = "Directory (relative to home) whose repositories use the work Git identity.";
      type = types.str;
      default = "work";
    };
  };

  config = mkIf cfg.enable {
    eclipse.hm = {config, ...}: {
      programs.git.includes = [
        {
          path = "${config.home.homeDirectory}/${cfg.directory}/.gitconfig";
          condition = "gitdir:${config.home.homeDirectory}/${cfg.directory}/";
        }
      ];

      home.file."${cfg.directory}/.gitconfig".text = ''
        [user]
          name = "Martin Jonsson"
          email = "mjonsson@antmicro.com"

        [url "git@github.com-antmicro"]
          insteadOf = git@github.com
      '';
    };
  };
}
