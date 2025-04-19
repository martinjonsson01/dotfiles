{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Universal styling
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs pkgs-unstable;};
      modules = [
        ({
          config,
          pkgs,
          ...
        }: {
          nixpkgs = {
            config = {
              allowUnfree = true;
            };
            overlays =
              [
              ]
              ++ import ./overlays {inherit pkgs inputs;};
          };
        })
        ./modules/nixos/default.nix
        ./hosts/default/hardware-configuration.nix
        ./hosts/default/configuration.nix
        inputs.sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs pkgs-unstable;
            };
            users."martin" = {
              imports = [
                ./hosts/default/home.nix
              ];
            };
            # Extension to put on backup files.
            backupFileExtension = "hm-backup";
          };
        }
      ];
    };
  };
}
