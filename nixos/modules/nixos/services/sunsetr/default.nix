#
# Automatic blue light filter for Hyprland, Niri, and everything Wayland.
#
{
  config,
  pkgs,
  lib,
  ...
}: let
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
      maintainers = [];
      mainProgram = "sunsetr";
    };
  };

  settings = {
    #[Sunsetr configuration]
    backend = "auto"; # Backend to use: "auto", "hyprland" or "wayland"
    start_hyprsunset = true; # Set true if you're not using hyprsunset.service
    startup_transition = false; # Enable smooth transition when sunsetr starts
    startup_transition_duration = 10; # Duration of startup transition in seconds (10-60)
    night_temp = 3300; # Color temperature after sunset (1000-20000) Kelvin
    day_temp = 6500; # Color temperature during day (1000-20000) Kelvin
    night_gamma = 90; # Gamma percentage for night (0-100%)
    day_gamma = 100; # Gamma percentage for day (0-100%)
    update_interval = 60; # Update frequency during transitions in seconds (10-300)
    transition_mode = "finish_by"; # Select: "geo", "finish_by", "start_at", "center"

    #[Manual transitions]
    sunset = "19:30:00"; # Time to transition to night mode (HH:MM:SS) - ignored in geo mode
    sunrise = "05:00:00"; # Time to transition to day mode (HH:MM:SS) - ignored in geo mode
    transition_duration = 30; # Transition duration in minutes (5-120)
  };
in
  with lib; {
    options = {
      sunsetr.enable = lib.mkEnableOption "Enables sunsetr";
    };

    config = lib.mkIf config.sunsetr.enable {
      home-manager.users.martin = {
        home.packages = [sunsetr];

        xdg.configFile."sunsetr/sunsetr.toml".source = pkgs.writers.writeTOML "sunsetr.toml" settings;

        systemd.user.services.sunsetr = {
          Unit = {
            Description = "Sunsetr - Automatic color temperature adjustment for Hyprland, Niri, and everything Wayland";
            PartOf = "graphical-session.target";
            Requires = "graphical-session.target";
            After = "graphical-session.target";
          };
          Service = {
            Type = "simple";
            ExecStart = "${getExe sunsetr}";
            Restart = "always";
            RestartSec = 30;
          };
          Install = {
            WantedBy = ["graphical-session.target"];
          };
        };
      };

      systemd.services.sunsetr-reload-on-resume = {
        enable = true;

        description = "Sunsetr reset to update state properly when resuming";
        after = ["suspend.target"];

        environment = {
          # Sunsetr looks up its lockfile containing the pid at this location.
          XDG_RUNTIME_DIR = "/run/user/1000";
        };

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "sleep 5 ; ${getExe sunsetr} --reload";
        };

        wantedBy = ["suspend.target"];
      };
    };
  }
