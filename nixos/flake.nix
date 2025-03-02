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

    # Fixes triple-buffering for Gnome 47.3 (should be included by default in Gnome 48)
    # https://nixos.wiki/wiki/GNOME#:~:text=specific%20dbus%20session.-,Dynamic%20triple%20buffering,-Big%20merge%20request
    mutter-triple-buffering-src = {
      url = "gitlab:vanvugt/mutter?ref=triple-buffering-v4-47&host=gitlab.gnome.org";
      flake = false;
    };
    gvdb-src = {
      url = "gitlab:GNOME/gvdb?ref=main&host=gitlab.gnome.org";
      flake = false;
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
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
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
