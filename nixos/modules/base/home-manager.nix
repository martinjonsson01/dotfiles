#
# Home Manager wiring shared by all users.
#
{inputs, ...}: {
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
      inputs.niri.homeModules.niri
      inputs.nixvim.homeModules.nixvim
      inputs.sops-nix.homeManagerModule
    ];
  };
}
