#
# Nix itself: registry, store hygiene and unfree packages.
#
{
  inputs,
  config,
  lib,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Run programs without installing them, e.g. `, cowsay hello`.
  programs.nix-index-database.comma.enable = true;

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      download-buffer-size = 536870912; # (512 MiB) The size of Nix's internal download buffer during curl transfers.
    };

    gc = {
      automatic = true;
      dates = "weekly";
      # Delete older generations too
      options = "--delete-older-than 14d";
    };
  };
}
