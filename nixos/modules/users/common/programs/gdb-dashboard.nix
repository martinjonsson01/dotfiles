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

    home.file.".gdbinit".text = ''
      source ${gdb-dashboard-gdbinit}

      # Set dashboard style
      define src
        dashboard -layout expressions registers source variables stack
        dashboard source -style height 20
      end

      define asm
        dashboard -layout expressions assembly registers
        dashboard assembly -style height 20
      end

      src

      # Auto-accept pending breakpoints
      set breakpoint pending on

      # Store GDB command history in ~/.gdb_history
      set history filename ~/.gdb_history

      # Enable automatic saving of command history
      set history save on

      # Allow unlimited history entries
      set history size unlimited

      # Remove duplicate entries from history
      set history remove-duplicates unlimited

      # Enable history expansion (like !n to repeat nth command)
      set history expansion on
    '';
  };
}
