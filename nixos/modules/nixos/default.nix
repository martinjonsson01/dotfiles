{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./system/nvidia.nix
  ];
}
