{
  description = "Martin's system Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix-based user environment configurator.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Scrollable-tiling desktop environment.
    niri = {
      url = "github:sodiboo/niri-flake/e3d4bf00f7d40fca03fecab5c7a46277a6eb9fed";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-unstable.url = "github:martinjonsson01/niri/aa0a3a25db36e47083de3cf0780db34bd99f46c4";
    };

    # Universal styling
    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A Neovim distribution built around Nix modules.
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Automatically updating nix-index.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # One formatter entry point for the whole tree.
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Offline push-to-talk speech-to-tech program.
    handy = {
      url = "github:cjpais/Handy";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.bun2nix.inputs.systems.url = "github:nix-systems/default-linux";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    importTree = import ./lib/importTree.nix;

    system = "x86_64-linux";
    treefmtEval = inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
      projectRootFile = "flake.nix";
      programs.alejandra.enable = true;
      programs.shfmt.enable = true;
      programs.prettier.enable = true;
      programs.ruff-format.enable = true;
      settings.global.excludes = ["secrets/*"];
    };

    mkHost = host:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules =
          (importTree ./modules)
          ++ [
            ./overlays/unstable.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.stylix.nixosModules.stylix
            inputs.nix-index-database.nixosModules.nix-index
            inputs.handy.nixosModules.default
            ./hosts/${host}
          ];
      };
  in {
    nixosConfigurations = {
      Femto = mkHost "Femto";
      Idea = mkHost "Idea";
    };

    formatter.${system} = treefmtEval.config.build.wrapper;
    checks.${system}.formatting = treefmtEval.config.build.check inputs.self;
  };
}
