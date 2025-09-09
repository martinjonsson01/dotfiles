#
# Modular visual interface for GDB in Python.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  repo = "cyrus-and/gdb-dashboard";
  file = ".gdbinit";
  commit = "616ed5100d3588bb70e3b86737ac0609ce0635cc";
  gdb-dashboard-gdbinit = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/${repo}/${commit}/${file}";
    sha256 = "sha256-cLpH7t/oK8iFOfDnfnWw3oLGegYnNEb5vI8M7FGI7ic=";
  };
in {
  options = {
    gdb-dashboard.enable = mkEnableOption "Enables gdb-dashboard";
  };

  config = mkIf config.gdb-dashboard.enable {
    home.packages = with pkgs; [
      gdb
      python313Packages.pygments
    ];

    home.file.".gdbinit".source = gdb-dashboard-gdbinit;
  };
}
