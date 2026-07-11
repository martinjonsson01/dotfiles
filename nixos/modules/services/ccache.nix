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
  options.eclipse.ccache.enable = mkEnableOption "ccache";

  config = mkIf config.eclipse.ccache.enable {
    environment.systemPackages = with pkgs; [
      ccache
    ];

    eclipse.hm.home.sessionVariables = {
      CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
      CMAKE_C_COMPILER_LAUNCHER = "ccache";
    };
  };
}
