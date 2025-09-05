{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.Eclipse.users.martin;
in {
  options.Eclipse.users.martin.enable = mkEnableOption "Enables martin user account";

  config = mkIf cfg.enable {
    home-manager.users.martin = {
      imports = [
        ./common
      ];

      home = {
        username = "martin";
        homeDirectory = "/home/martin";

        # This value determines the Home Manager release that your configuration is
        # compatible with. This helps avoid breakage when a new Home Manager release
        # introduces backwards incompatible changes.
        #
        # You should not change this value, even if you update Home Manager. If you do
        # want to update the value, then make sure to first check the Home Manager
        # release notes.
        stateVersion = "24.11"; # Please read the comment before changing.
      };

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # Secrets management
      sops = {
        defaultSopsFile = ./../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";

        # This will automatically import SSH keys as age keys
        age.sshKeyPaths = ["/home/martin/.ssh/id_ed25519"];
      };

      #
      # These should really be in the profiles, but I can't find a way to
      # enable them from the profile module... :(
      #

      git.enable = true;
      neovim.enable = true;
      fish.enable = true;
      niri.enable = true;
      kitty.enable = true;
      lutris.enable = true;
      tokyonight.enable = true;

      services.swayosd.enable = true;

      # Desktop add-ons
      gtk-theme.enable = true;
      waybar.enable = true;
      nwg-bar.enable = true;
      swaync.enable = true;
      blueman-applet.enable = true;
      nm-applet.enable = true;
      fuzzel.enable = true;
      swayidle.enable = true;
      copyq.enable = true;

      vscode.enable = true;
      jetbrains.enable = true;
      zellij.enable = true;
      podman.enable = true;

      plex-desktop.enable = true;
      pinta.enable = true;
      mpv.enable = true;
      decibels.enable = true;
      loupe.enable = true;

      zoom.enable = true;

      btop.enable = true;
      qalculate.enable = true;
      screenrecord-region.enable = true;
      screenshot-region.enable = true;
      open-screenshot-dir.enable = true;
      search-google.enable = true;
      search-github-nix.enable = true;
      satty.enable = true;

      home.packages = with pkgs;
        [
          nerd-fonts.jetbrains-mono # Font with icons
          nautilus # Necessary for file pickers, even if not used as primary file explorer.
          swappy # Necessary for screenshot script

          nil # LSP for Nix
          sops # Secrets management
          pre-commit # Hooks that run before committing
          gcc # GNU Compiler Collection

          kdePackages.okular # KDE document viewer
          komikku # Comic reader

          discord
          slack
          hexchat # IRC Client

          # CLI
          fd # Simple, fast and user-friendly alternative to find
          bat # Cat(1) clone with syntax highlighting and Git integration
          dust # Disk usage utility written in Rust
          thefuck # Fixes last run command
          jq # JSON parsing/querying

          # Utility
          fsearch # Like Void Tools Everything but on linux (i.e. file search)
          rofimoji # Emoji selector
          gparted # Disk partition editing/viewing tool
          python310 # Scripting
          curl # Command line tool for transferring files with URL syntax
          wget # Tool for retrieving files using HTTP, HTTPS, and FTP
          ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
          yt-dlp # To download youtube videos
          video-trimmer # For trimming video files
          dysk # Simple and easy to view disk usage
          songrec # Shazam song recognition
        ]
        ++ (with pkgs.unstable; [
          comma # Place a , in front of a command to run software without installing it.
          plexamp # Self-hosted music
        ]);
    };

    users = {
      users.martin = {
        isNormalUser = true;
        description = "Martin";
        uid = 1000;
        extraGroups = [
          "networkmanager"
          "wheel"
          "rslsync"
          "docker"
        ];
      };

      groups."martin".gid = 1000;
    };
  };
}
