#
# Open Source gaming platform for GNU/Linux.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    lutris.enable = mkEnableOption "Enables lutris";
  };

  config = mkIf config.lutris.enable {
    programs.lutris = {
      enable = true;
      protonPackages = [pkgs.proton-ge-bin];
      extraPackages = with pkgs; [
        mangohud # Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more
        winetricks # Script to install DLLs needed to work around problems in Wine
        gamescope # SteamOS session compositing window manager
        gamemode # Optimise Linux system performance on demand
        umu-launcher # Unified launcher for Windows games on Linux using the Steam Linux Runtime and Tools
        bottles # Easily run Windows software on Linux with Bottles! (wine)
      ];
    };
  };
}
