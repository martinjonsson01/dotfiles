#
# Powerful yet simple to use screenshot software.
#
{
  lib,
  pkgs,
  config,
  ...
}: let
  flameshotGrim = pkgs.flameshot.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "flameshot-org";
      repo = "flameshot";
      rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
      sha256 = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
    };
    cmakeFlags = [
      "-DUSE_WAYLAND_CLIPBOARD=1"
      "-DUSE_WAYLAND_GRIM=1"
    ];
    buildInputs = oldAttrs.buildInputs ++ [pkgs.libsForQt5.kguiaddons];
  });
in {
  options = {
    flameshot.enable = lib.mkEnableOption "Enables Flameshot";
  };

  config = lib.mkIf config.flameshot.enable {
    services.flameshot = {
      enable = true;
      package = flameshotGrim;
      settings = {
        General = {
          uiColor = "#1435c7";
        };
      };
    };
  };
}
