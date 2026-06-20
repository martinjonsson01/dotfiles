#
# Automatic blue light filter for Hyprland, Niri, and everything Wayland.
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  settings = {
    #[Sunsetr configuration]

    #[Backend]
    backend = "wayland"; # Backend to use: "auto", "hyprland", "hyprsunset" or "wayland"
    transition_mode = "finish_by"; # Select: "geo", "finish_by", "start_at", "center", "static"

    #[Smoothing]
    smoothing = true; # Enable smooth transitions during startup and exit
    startup_duration = 0.5; # Duration of smooth startup in seconds (0.1-60 | 0 = instant)
    shutdown_duration = 0.5; # Duration of smooth shutdown in seconds (0.1-60 | 0 = instant)
    adaptive_interval = 1; # Adaptive interval base for smooth transitions (1-1000)ms

    night_temp = 3300; # Color temperature after sunset (1000-20000) Kelvin
    day_temp = 6500; # Color temperature during day (1000-20000) Kelvin
    night_gamma = 90; # Gamma percentage for night (0-100%)
    day_gamma = 100; # Gamma percentage for day (0-100%)
    update_interval = 10; # Update frequency during transitions in seconds (10-300)

    #[Manual transitions]
    sunset = "20:00:00"; # Time to transition to night mode (HH:MM:SS) - ignored in geo mode
    sunrise = "05:00:00"; # Time to transition to day mode (HH:MM:SS) - ignored in geo mode
    transition_duration = 30; # Transition duration in minutes (5-120)
  };
in
  with lib; {
    options = {
      sunsetr.enable = lib.mkEnableOption "Enables sunsetr";
    };

    config = lib.mkIf config.sunsetr.enable {
      environment.systemPackages = with pkgs.unstable; [
        sunsetr
      ];

      sops.secrets."geo.toml" = {
        sopsFile = ./../../../secrets/geo.toml;
        format = "binary";
        mode = "444";
      };

      home-manager.users.martin = {lib, ...}: {
        xdg.configFile."sunsetr/sunsetr.toml".source = pkgs.writers.writeTOML "sunsetr.toml" settings;
        home.activation.placeResilioSecret = lib.hm.dag.entryAfter ["writeBoundary"] ''
          mkdir -p $HOME/.config/sunsetr
          ln -sf ${config.sops.secrets."geo.toml".path} $HOME/.config/sunsetr/geo.toml
        '';

        systemd.user.services.sunsetr = {
          Unit = {
            Description = "Sunsetr - Automatic color temperature adjustment for Hyprland, Niri, and everything Wayland";
            PartOf = "graphical-session.target";
            Requires = "graphical-session.target";
            After = "graphical-session.target";
          };
          Service = {
            Type = "simple";
            ExecStart = "${getExe pkgs.unstable.sunsetr}";
            Restart = "always";
            RestartSec = 30;
            PassEnvironment = [
              "WAYLAND_DISPLAY"
              "XDG_RUNTIME_DIR"
              "NIRI_SOCKET"
            ];
          };
          Install = {
            WantedBy = ["graphical-session.target"];
          };
        };
      };
    };
  }
