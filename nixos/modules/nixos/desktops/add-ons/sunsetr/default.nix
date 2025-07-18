#
# Automatic blue light filter for Hyprland, Niri, and everything Wayland.
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  startTime = "19:00:00";
  endTime = "05:00:00";
  temperature = 3000;

  sunsetr = pkgs.rustPlatform.buildRustPackage rec {
    pname = "sunsetr";
    version = "0.5.0";

    src = pkgs.fetchFromGitHub {
      owner = "psi4j";
      repo = "sunsetr";
      rev = "v${version}";
      hash = "sha256-VgPD1qa5NGJXkrYMSfUUY1cGwqXdQLHfIV7lqHrV3ic=";
    };

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    postPatch = ''
      ln -s ${./Cargo.lock} Cargo.lock
    '';

    meta = with lib; {
      description = "Automatic blue light filter for Hyprland, Niri, and everything Wayland";
      homepage = "https://github.com/psi4j/sunsetr";
      license = licenses.mit;
      maintainers = with maintainers; [];
      mainProgram = "sunsetr";
    };
  };
in
  with lib; {
    options = {
      sunsetr.enable = lib.mkEnableOption "Enables sunsetr";
    };

    config = lib.mkIf config.sunsetr.enable {
      environment.systemPackages = [
        sunsetr
      ];
    };
  }
