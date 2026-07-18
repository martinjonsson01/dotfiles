{...}: {
  imports = [
    ./hardware-configuration.nix
    ./facts.nix
  ];

  networking.hostName = "Idea";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Custom modules
  eclipse = {
    # All projects live in the same directory on this machine.
    work.directory = "Projects";

    # Enable profiles
    core.enable = true;
    desktop.enable = true;
    dev.enable = true;
    util.enable = true;
    work.enable = true;

    # This is a work machine, so instead of the whole social profile only Slack is needed.
    hm = {pkgs, ...}: {
      home.packages = [pkgs.slack];
    };
  };

  eclipse.users.martin = {
    enable = true;
    authorizedKeyFiles = [./id_mjonsson.pub];
  };

  # Harden SSH; this machine accepts remote logins.
  services.openssh = {
    ports = [22];
    settings.PasswordAuthentication = false;
  };

  # Disable built-in motherboard bluetooth (it has crap range)
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3558", ATTR{authorized}="0"
  '';
}
