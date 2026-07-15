{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./facts.nix
  ];

  networking.hostName = "Femto";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Custom modules
  eclipse = {
    nvidia.enable = true;
    teamviewer.enable = true;
    activitywatch.syncDir = "/big-chungus/Drive/activity";
    syncthing.driveDir = "/big-chungus/Drive";

    # Enable profiles
    ai.enable = true;
    core.enable = true;
    desktop.enable = true;
    dev.enable = true;
    gaming.enable = true;
    media.enable = true;
    social.enable = true;
    util.enable = true;
    work.enable = true;
  };

  eclipse.users.martin.enable = true;

  # Configure swap
  swapDevices = [
    {
      device = "/swapfile";
      size = 64 * 1024; # 64GiB
    }
  ];

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
  eclipse.rtl8761bu-firmware.enable = true; # Necessary to replace the newest firmware which causes disconnects

  services.udev.extraRules = ''
    # Keep the Razer Kiyo Pro fully powered; USB autosuspend can crash it off the bus
    SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="0e05", ATTR{power/control}="on"
  '';

  # Automatically give users keyboard hardware access.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "qmk-rules";
      destination = "/etc/udev/rules.d/50-qmk.rules";
      text = builtins.readFile ./qmk.rules;
    })
  ];

  services.printing.drivers = with pkgs; [
    brlaser # CUPS driver for Brother laser printers.
  ];

  environment.systemPackages = with pkgs; [
    wakeonlan # Perl script for waking up computers via Wake-On-LAN magic packets
  ];

  # GameMode is a daemon/lib combo for Linux that allows games to request a set of
  # optimisations be temporarily applied to the host OS and/or a game process.
  programs.gamemode.enable = true;
}
