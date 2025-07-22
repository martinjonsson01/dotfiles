{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
}: {
  options = {
    fish.enable = lib.mkEnableOption "Enables fish";
  };

  config = lib.mkIf config.fish.enable {
    home.packages = with pkgs; [
      grc # Generic text colouriser
      babelfish # Translate bash scripts to fish.
    ];

    home.file = {
      # Fish files
      ".config/fish/functions" = {
        source = ./functions;
        recursive = true;
      };

      # Necessary for command-not-found function.
      "bin/nix-command-not-found" = {
        text = ''
          #!/usr/bin/env bash
          source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
          command_not_found_handle "$@"
        '';

        executable = true;
      };
    };

    #
    # Commands with fish integration.
    #
    programs = {
      # Command-line fuzzy finder written in Go
      fzf.enable = true;
      fzf.enableFishIntegration = true;
      # Next gen ls command
      lsd.enable = true;
      lsd.enableFishIntegration = true;
      # Fast cd command that learns your habits
      zoxide.enable = true;
      zoxide.enableFishIntegration = true;
      zoxide.options = ["--cmd cd"];
      # Interactive directory tree view.
      broot.enable = true;
      broot.enableFishIntegration = true;
      # Shell extension that manages your environment
      direnv.enable = true;
      direnv.nix-direnv.enable = true;
      # Creates programs.sqlite database for command-not-found.
      nix-index.enable = true;
      nix-index.enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;

      plugins = [
        # Colorizes command output
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        # Auto-complete matching pairs in the Fish command line
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        # Automatically receive notifications when long processes finish
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        # Keeps your fish shell history clean from typos,
        # incorrectly used commands
        # and everything you don't want to store due to privacy reasons
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
        # Adds color to man pages
        {
          name = "colored-man-pages";
          src = pkgs.fishPlugins.colored-man-pages.src;
        }
        # Support for `nix-shell`
        {
          name = "foreign-env";
          src = pkgs.fishPlugins.foreign-env.src;
        }
        # Quick directory jumping
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
      ];

      interactiveShellInit = ''
        set -g fish_greeting "fastfetch"

        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        ${pkgs.thefuck}/bin/thefuck --alias | source

        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
        set -gx FZF_ALT_C_COMMAND 'fd --type d .'

        # Set Fish colors that aren't dependant the `$term_background`.
        set -g fish_color_quote        cyan      # color of commands
        set -g fish_color_redirection  brmagenta # color of IO redirections
        set -g fish_color_end          blue      # color of process separators like ';' and '&'
        set -g fish_color_error        red       # color of potential errors
        set -g fish_color_match        --reverse # color of highlighted matching parenthesis
        set -g fish_color_search_match --background=yellow
        set -g fish_color_selection    --reverse # color of selected text (vi mode)
        set -g fish_color_operator     green     # color of parameter expansion operators like '*' and '~'
        set -g fish_color_escape       red       # color of character escapes like '\n' and and '\x70'
        set -g fish_color_cancel       red       # color of the '^C' indicator on a canceled command
      '';
    };

    # Aliases
    home.shellAliases = with pkgs; {
      # Nix related
      rebuild = "~/dotfiles/nixos/rebuild.sh";
      nb = "nix build";
      nd = "nix develop";
      nf = "nix flake";
      nr = "nix run";
      ns = "nix search";

      # Other
      cat = "${bat}/bin/bat";
      du = "${du-dust}/bin/dust";
      g = "${gitAndTools.git}/bin/git";
      lg = "${pkgs-unstable.lazygit}/bin/lazygit";
      ls = "${lsd}/bin/lsd";
      kubectl = "kubecolor"; # Use colorized version of kubectl
      k = "kubectl"; # Without reference to package since it's inside a shell.nix
      salmon = "/home/martin/redacted/smoked-salmon/.venv/bin/python3 /home/martin/redacted/smoked-salmon/run.py";
    };
  };
}
