{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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
      url = "github:martinjonsson01/niri-flake/2f6b0cfe0419bac27f3d91ca1f22a4a53ee1e485";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-stable.url = "github:martinjonsson01/niri/5ae7e29230d632ad6fcdd5c4fdba9f7653ca393f";
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
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    niri,
    rust-overlay,
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

              # Fix collisions.
              packageOverrides = pkgs: {
                swaylock = pkgs.lowPrio pkgs.swaylock;
                swaylock-effects = pkgs.hiPrio pkgs.swaylock-effects;
              };
            };
            overlays =
              [
                rust-overlay.overlays.default
              ]
              ++ import ./overlays {inherit pkgs inputs;};
          };
          # For the rust-overlay
          environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
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
                inputs.niri.homeModules.niri
                ./hosts/default/home.nix
              ];
            };
            # Extension to put on backup files.
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
