{
  pkgs,
  inputs,
  ...
}: {
  config.nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
  ];

  config.environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
}
