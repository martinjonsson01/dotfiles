{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./hardware-configuration.nix
    ./peripherals.nix
  ];

  networking.hostName = "Femto";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      download-buffer-size = 536870912; # (512 MiB) The size of Nix's internal download buffer during curl transfers.
    };

    gc = {
      automatic = true;
      dates = "weekly";
      # Delete older generations too
      options = "--delete-older-than 14d";
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # This will automatically import SSH keys as age keys.
  sops.age.sshKeyPaths = ["/home/martin/.ssh/id_ed25519"];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Needed for trash to work.
  services.gvfs.enable = true;

  # Thumbnailer service for file managers.
  services.tumbler.enable = true;

  # Power monitoring deamon (i.e. mouse/bluetooth battery).
  services.upower.enable = true;

  # Docker containers
  virtualisation.docker.enable = true;

  # Necessary to make login using swaylock possible.
  security.pam.services.swaylock = {};

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    brlaser # CUPS driver for Brother laser printers.
  ];
  # Enable automatic finding and configuring of printers.
  services.printing.browsing = true;
  services.printing.browsedConf = ''
    BrowseDNSSDSubTypes _cups,_print
    BrowseLocalProtocols all
    BrowseRemoteProtocols all
    CreateIPPPrinterQueues All

    BrowseProtocols all
  '';
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Configure swap
  swapDevices = [
    {
      device = "/swapfile";
      size = 64 * 1024; # 64GiB
    }
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Name = "Hello";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  rtl8761bu-firmware.enable = true; # Necessary to replace the newest firmware which causes disconnects

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged
    # programs here, NOT in environment.systemPackages.
    fontconfig
    wayland
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
  ];

  environment.systemPackages = with pkgs; [
    # Programs
    google-chrome # Web browser

    # CLI
    wget # For downloading
    alejandra # Nix formatter
    tree # Shows directory structures
    fastfetch # Shows system info

    # System
    libnotify # For notifications
    cmake # For building
  ];

  # GameMode is a daemon/lib combo for Linux that allows games to request a set of
  # optimisations be temporarily applied to the host OS and/or a game process.
  programs.gamemode.enable = true;

  # Disable built-in MSI b650i motherboard bluetooth (it has crap range)
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="0616", ATTR{authorized}="0"
  '';

  # Automatically give users keyboard hardware access.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "qmk-rules";
      destination = "/etc/udev/rules.d/50-qmk.rules";
      text = builtins.readFile ./qmk.rules;
    })
  ];

  # Custom modules
  Eclipse = {
    nvidia.enable = true;
    stylix.enable = true;
    teamviewer.enable = true;
    steam.enable = true;

    # Enable profiles
    core.enable = true;
    dev.enable = true;
    media.enable = true;
    social.enable = true;
    util.enable = true;

    users.martin.enable = true;
  };
}
