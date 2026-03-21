{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  host = osConfig.networking.hostName;
  workDir =
    if host == "Idea"
    then "Projects"
    else "work";
in {
  options = {
    git.enable = mkEnableOption "Enables git";
  };

  config = mkIf config.git.enable {
    programs.git = {
      enable = true;
      package = pkgs.unstable.git;
      userName = "Martin";
      userEmail = "martinjonsson01@gmail.com";
      includes = [
        {
          path = "${config.home.homeDirectory}/${workDir}/.gitconfig";
          condition = "gitdir:${config.home.homeDirectory}/${workDir}/";
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
        color.ui = "auto";
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
        blame.ignoreRevsFile = ":(optional).git-blame-ignore-revs";
      };
    };

    # Syntax-aware diff
    programs.difftastic = {
      enable = true;
      git.enable = true;
      options = {
        enableAsDifftool = true;
        background = "dark";
      };
    };

    home.sessionVariables = {
      # Difftastic: Allow more errors before switching to textual diff.
      DFT_PARSE_ERROR_LIMIT = 100;
    };

    home.packages = with pkgs; [
      git-absorb # git commit --fixup, but automatic
      commitizen # Commit rules
    ];

    xdg.configFile."git/ignore".source = ./ignore;

    home.file."${workDir}/.gitconfig".text = ''
      [user]
          email = "mjonsson@antmicro.com"
          name = "Martin Jonsson"
    '';

    programs.lazygit = {
      enable = true;
      package = pkgs.unstable.lazygit;
      settings = {
        os = {
          editPreset = "nvim";
        };

        git = {
          pagers = [
            {
              externalDiffCommand = "difft --color=always";
            }
          ];
          commitPrefix = [
            {
              pattern = "^([^-]+)-.*"; # Take all text prior to the first dash
              replace = "[#$1] ";
            }
          ];
        };

        gui = {
          showDivergenceFromBaseBranch = "arrowAndNumber";
        };

        quitOnTopLevelReturn = true;
        disableStartupPopups = true;
        promptToReturnFromSubprocess = false;

        customCommands = [
          {
            key = "C";
            command = "git cz c";
            description = "commit with commitizen";
            context = "files";
            loadingText = "opening commitizen commit tool";
            output = "terminal";
          }
        ];
      };
    };
  };
}
