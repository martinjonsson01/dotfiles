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
