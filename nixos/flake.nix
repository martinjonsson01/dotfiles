{
  description = "Martin's system Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix-based user environment configurator.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Scrollable-tiling desktop environment.
    niri = {
      url = "github:martinjonsson01/niri-flake/bdc23782b085a238339ba91882865a24fb49336a";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-stable.url = "github:martinjonsson01/niri/26e793de0e81ee1b027b0bdf3e62f30a40e9a8e1";
    };

    # Universal styling
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # To build rust packages.
    rust-overlay = {
      url = "github:oxalica/rust-overlay/dc221f842e9ddc8c0416beae8d77f2ea356b91ae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A Neovim distribution built around Nix modules.
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    sops-nix,
    stylix,
    niri,
    nixvim,
    ...
  }: let
    # Shared modules and imports
    defaultModules = [
      ./modules/autoimport.nix
      ./overlays/unstable.nix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = {
            inherit inputs;
          };

          /*
          When running, Home Manager will use the global package cache.
          It will also back up any files that it would otherwise overwrite.
          The originals will have the extension shown below.
          */
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "home-manager-backup";

          # Modules shared across all users
          sharedModules = [
            niri.homeModules.niri
            nixvim.homeModules.nixvim
            sops-nix.homeManagerModule
          ];
        };
      }
      sops-nix.nixosModules.sops
      stylix.nixosModules.stylix
      ({...}: {
        nixpkgs.config = {
          allowUnfree = true;

          # Fix collisions.
          packageOverrides = pkgs: {
            swaylock = pkgs.lowPrio pkgs.swaylock;
            swaylock-effects = pkgs.hiPrio pkgs.swaylock-effects;
          };
        };
      })
    ];
  in {
    nixosConfigurations = {
      Femto = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./hosts/Femto
          ];
      };
      Idea = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./hosts/Idea
          ];
      };
    };
  };
}
