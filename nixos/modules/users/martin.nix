{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  eclipse.users.martin = {
    description = "Martin";
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
      "rslsync"
      "docker"
      "input"
      "uinput"
    ];
    stateVersion = "24.11";
  };

  home-manager.users.martin = mkIf config.eclipse.users.martin.enable {
    #
    # These should really be in the profiles, but I can't find a way to
    # enable them from the profile module... :(
    #

    git.enable = true;
    gh.enable = true;
    neovim.enable = true;
    fish.enable = true;
    niri.enable = true;
    kitty.enable = true;
    lutris.enable = true;
    tokyonight.enable = true;
    ssh.enable = true;

    # Audio
    easyeffects.enable = true;
    mic-default-mute.enable = true;

    services.swayosd.enable = true;

    # Local LLM
    ollama.enable = true;
    openWebui.enable = true;
    handy.enable = true; # Dictation

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
    yazi.enable = true;
    qalculate.enable = true;
    screenrecord-region.enable = true;
    screenshot-region.enable = true;
    open-screenshot-dir.enable = true;
    search-google.enable = true;
    search-github-nix.enable = true;
    niri-rename-workspace.enable = true;
    niri-launch-kitty-workspace-cwd.enable = true;
    lock-script.enable = true;
    satty.enable = true;
    gdb-dashboard.enable = true;

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
        jq # JSON parsing/querying
        yq # YAML parsing/querying
        ripgrep # Faster grep
        fd # More intuitive 'find'
        openssl_3 # Cryptography
        mkvtoolnix # Mkv editing
        websocat # Connect to websockets
        ethtool # Utility for controlling network drivers and hardware

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
        (pkgs.linkFarm "runghc" [
          {
            name = "bin/runghc";
            path = "${pkgs.ihaskell}/bin/runghc";
          }
        ]) # Run Haskell scripts
      ]
      ++ (with pkgs.unstable; [
        (plexamp.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [makeWrapper];
          buildCommand = ''
            ${old.buildCommand}
            source "${makeWrapper}/nix-support/setup-hook"
            wrapProgram "$out/bin/plexamp" --add-flags "--disable-gpu"
          '';
        }))
      ]);
  };
}
