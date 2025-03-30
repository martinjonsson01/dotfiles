# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  myHardware = {
    cpu = "amd";
    gpuDriver = "nvidia";
    monitors = [
      # Acer 144hz 27" monitor. card1-DP-5     2560x1440
      {
        name = "DP-5";
        width = 2560;
        height = 1440;
        refreshRate = 144.0;
        rotation = 3;
        x = 5120;
        wallpaper = ./wallpapers/kanagawa-dark.jpg;
        workspaces = [
          8
        ];
      }
      # Samsung ultrawide 49" monitor. card1-DP-6     5120x1440
      {
        name = "DP-6";
        width = 5120;
        height = 1440;
        refreshRate = 120.0;
        primary = true;
        x = 0;
        wallpaper = ./wallpapers/skull2.png;
        workspaces = [
          1
          2
          3
          4
          5
          6
          7
        ];
      }
      # Samsung 24" monitor. card1-HDMI-A-2 1920x1080
      {
        name = "HDMI-A-2";
        width = 1920;
        height = 1080;
        x = -1920;
        wallpaper = ./wallpapers/kanagawa-dark.jpg;
        workspaces = [
          9
        ];
      }
    ];

    audio = {
      # List sink IDs using `wpctl status`
      # Get sink node.name using `wpctl inspect [ID]`
      disabledMatches = [
        "node.name = \"alsa_output.usb-Generic_USB_Audio-00.HiFi__Headphones__sink\""
        "node.name = \"alsa_output.pci-0000_01_00.1.hdmi-stereo\""
        "node.name = \"alsa_output.usb-Elgato_Systems_Elgato_Wave_3_BS01K1A01450-00.analog-stereo\""
        "device.nick = \"HDA NVidia\""
        "device.name = \"alsa_card.pci-0000_10_00.1\""
      ];

      sinkPriorityMatches = [
        "node.name = \"bluez_output.38_18_4C_05_C3_B1.1\"" # WH-1000XM3
        "node.name = \"alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink\"" # Speakers plugged into motherboard
      ];
    };
  };

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

  # Secrets management
  sops = {
    defaultSopsFile = ./../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = ["/home/martin/.ssh/id_ed25519"];
  };

  nvidia.enable = true;
  custom-style.enable = true;
  fish.enable = true;
  polkit-gnome.enable = true;
  resilio.enable = true;
  audio.enable = true;
  teamviewer.enable = true;

  # Docker containers
  virtualisation.docker.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged
    # programs here, NOT in environment.systemPackages.
    fontconfig
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.xinput
  ];

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "martin";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Programs
    google-chrome # Web browser

    # CLI
    wget # For downloading
    alejandra # Nix formatter
    tree # Shows directory structures

    # System
    libnotify # For notifications
    cmake # For building
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.martin = {
    isNormalUser = true;
    description = "Martin";
    extraGroups = ["networkmanager" "wheel" "rslsync" "docker"];
    packages = with pkgs; [
      hexchat # IRC Client
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.udev.extraRules = ''
    # Disable built-in MSI b650i motherboard bluetooth (it has crap range)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="0616", ATTR{authorized}="0"
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
