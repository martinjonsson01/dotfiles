{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/default.nix
    inputs.sops-nix.homeManagerModule
  ];

  # Secrets management
  sops = {
    defaultSopsFile = ./../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = ["/home/martin/.ssh/id_ed25519"];
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "martin";
  home.homeDirectory = "/home/martin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Social
    discord
    slack

    # Dev
    nil # LSP for Nix
    sops # Secrets management
    pre-commit # Hooks that run before committing
    gcc # GNU Compiler Collection
    jetbrains.rust-rover # Rust IDE

    # CLI
    fd # Simple, fast and user-friendly alternative to find
    bat # Cat(1) clone with syntax highlighting and Git integration
    dust # Disk usage utility written in Rust
    thefuck # Fixes last run command
    comma # Place a , in front of a command to run software without installing it.

    # Utility
    fsearch # Like Void Tools Everything but on linux (i.e. file search)
    rofimoji # Emoji selector
    gparted # Disk partition editing/viewing tool
    python310 # Scripting
    curl # Command line tool for transferring files with URL syntax
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
    yt-dlp # To download youtube videos

    # Music utils
    sox # Sample Rate Converter for audio
    flac # Library and tools for encoding and decoding the FLAC lossless audio file format
    mp3val # Tool for validating and repairing MPEG audio streams

    # Style
    nerd-fonts.jetbrains-mono # Font with icons

    # Media
    plexamp # Self-hosted music
    vlc # Media player
    kdePackages.okular # KDE document viewer
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store.  Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/martin/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable modules.
  git.enable = true;
  vscode.enable = true;
  autostart.enable = true;
  rbw.enable = true;
  rofi.enable = true;
  rofi-rbw.enable = true;
  fish.enable = true;
  satty.enable = true;
  plex-desktop.enable = true;
  btop.enable = true;
  zoom.enable = true;
  pinta.enable = true;
  niri.enable = true;
  qalculate.enable = true;
  kitty.enable = true;
  screenrecord-region.enable = true;
  screenshot-region.enable = true;
  open-screenshot-dir.enable = true;
  nemo.enable = true;

  # Desktop add-ons
  gtk-theme.enable = true;
  gnome-screenshot.enable = true;
  waybar.enable = true;
  nwg-bar.enable = true;
  dunst.enable = true;
  blueman-applet.enable = true;
  nm-applet.enable = true;
  fuzzel.enable = true;
  swayidle.enable = true;
  sunsetr.enable = true;
}
