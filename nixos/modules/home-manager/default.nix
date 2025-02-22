{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./vscode.nix
    ./gnome.nix
  ];
}
