#
# Compiler cache for fast recompilation of C/C++ code.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    ccache.enable = mkEnableOption "Enables ccache";
  };

  config = mkIf config.ccache.enable {
    environment.systemPackages = with pkgs; [
      ccache
    ];

    home-manager.users.martin.home.sessionVariables = {
      CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
      CMAKE_C_COMPILER_LAUNCHER = "ccache";
    };
  };
}
