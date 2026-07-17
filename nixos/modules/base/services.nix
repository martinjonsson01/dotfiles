#
# Baseline services and packages every host gets.
#
{
  config,
  lib,
  pkgs,
  ...
}: {
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
    libx11
    libxcursor
    libxext
    libxi
  ];

  environment.systemPackages = with pkgs; [
    # Programs
    # Web browser. NVIDIA's EGL driver rejects DMA-BUF pixmap imports on
    # Wayland (eglCreateImage EGL_BAD_MATCH), which turns the camera feed
    # white when sites apply video effects; software compositing avoids
    # that path.
    (google-chrome.override {
      commandLineArgs =
        lib.optionalString config.eclipse.nvidia.enable
        "--disable-gpu-compositing";
    })

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
