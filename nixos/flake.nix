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

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    sops-nix,
    stylix,
    niri,
    nixvim,
    nix-index-database,
    handy,
    ...
  }: let
    importTree = import ./lib/importTree.nix;

    # Shared modules and imports
    defaultModules =
      (importTree ./modules)
      ++ [
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
        nix-index-database.nixosModules.nix-index
        (
          {...}: {
            programs.nix-index-database.comma.enable = true;

            nixpkgs.config = {
              allowUnfree = true;

              # Fix collisions.
              packageOverrides = pkgs: {
                swaylock = pkgs.lib.lowPrio pkgs.swaylock;
                swaylock-effects = pkgs.lib.hiPrio pkgs.swaylock-effects;
              };
            };
          }
        )
        handy.nixosModules.default
        {
          programs.handy = {
            enable = true;
            package = inputs.handy.packages.x86_64-linux.default;
          };
        }
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
