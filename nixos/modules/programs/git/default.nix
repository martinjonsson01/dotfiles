{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.git.enable = mkEnableOption "git";

  config = mkIf config.eclipse.git.enable {
    eclipse.hm = {pkgs, ...}: {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "Martin";
            email = "martinjonsson01@gmail.com";
          };
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
          # TODO:reenable when updating to git 2.53.0 blame.ignoreRevsFile = ":(optional).git-blame-ignore-revs";
        };
      };

      # Syntax-aware diff (used by lazygit via externalDiffCommand; not wired into
      # git.diff.external so that plain `git diff` in the CLI works normally)
      programs.difftastic = {
        enable = true;
        git.enable = false;
        options = {
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
        git-crypt # For encrypting/decrypting files
      ];

      xdg.configFile."git/ignore".source = ./ignore;

      programs.lazygit = {
        enable = true;
        package = pkgs.unstable.lazygit;
        settings = {
          os = {
            editPreset = "nvim";
          };

          git = {
            commit.autoWrapCommitMessage = false;

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
            mouseEvents = false; # Allow text selection in the UI (disables mouse-clickable UI)
            skipAmendWarning = true; # I amend all the time
            skipRewordInEditorWarning = true; # When I want to edit using neovim I don't want warnings
            nerdFontsVersion = "3"; # Enable icons
            filterMode = "fuzzy"; # Use fuzzy search instead of strict substring match
            switchTabsWithPanelJumpKeys = true; # Press panel number again to switch tab
          };

          quitOnTopLevelReturn = true;
          disableStartupPopups = true;
          promptToReturnFromSubprocess = false;
          notARepository = "quit"; # Don't show the annoying popup menu when accidentally opening outside of a repo.

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
  };
}
