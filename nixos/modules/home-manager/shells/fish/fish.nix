{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    fish.enable = lib.mkEnableOption "Enables fish";
  };

  config = lib.mkIf config.fish.enable {
    home.packages = with pkgs; [
      grc # Generic text colouriser
      zoxide # A smarter cd command, inspired by z and autojump.
    ];

    # Fish files
    home.file.".config/fish/functions/fish_prompt.fish".source = ./functions/fish_prompt.fish;

    programs.fish = {
      enable = true;

      plugins = [
        # Colorizes command output
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
      ];

      interactiveShellInit = ''
        set -g fish_greeting ""
        ${pkgs.thefuck}/bin/thefuck --alias | source

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
      ":q" = "exit";
      cat = "${bat}/bin/bat";
      du = "${du-dust}/bin/dust";
      g = "${gitAndTools.git}/bin/git";
      la = "ll -a";
      lg = "${lazygit}/bin/lazygit";
    };
  };
}
