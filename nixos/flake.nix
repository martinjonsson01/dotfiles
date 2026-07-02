{
  description = "Martin's system Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix-based user environment configurator.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A Neovim distribution built around Nix modules.
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Automatically updating nix-index.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Offline push-to-talk speech-to-tech program.
    handy = {
      url = "github:cjpais/Handy";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    importTree = import ./lib/importTree.nix;

    mkHost = host:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
  };
}
