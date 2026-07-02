#
# Baseline services and packages every host gets.
#
{pkgs, ...}: {
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

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
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

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

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
}
