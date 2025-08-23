#
# Terminal workspace with batteries included.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  # Open new zellij session for the current directory.
  zns = "zellij -s (basename (pwd)) options --default-cwd (pwd)";
  # Restore zellij session in the current directory.
  zas = "zellij a (basename (pwd))";
  # Open zellij in current directory (restoring/creating session for it).
  zo = ''
    set session_name (basename "$(pwd)")

    zellij attach --create "$session_name" options --default-cwd "$(pwd)"
  '';
in {
  options = {
    zellij.enable = mkEnableOption "Enables zellij";
  };

  config = mkIf config.zellij.enable {
    home.shellAliases = {
      inherit zns zas zo;
    };

    programs.zellij = {
      enable = true;

      enableFishIntegration = false; # Don't autostart zellij.
    };

    xdg.configFile."zellij/config.kdl".text =
      # kdl
      ''
        ${builtins.readFile ./keybinds.kdl}

        // Fix for nixvim wrapped neovim
        // See https://github.com/zellij-org/zellij/issues/2925
        post_command_discovery_hook "echo \"$RESURRECT_COMMAND\" | sed 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/nix/store/.*/bin/||g'"

        copy_command "${getExe' pkgs.wl-clipboard "wl-copy"}"

        auto_layouts true

        default_shell "${getExe pkgs.fish}"
        show_startup_tips false
        default_layout "default"
        default_mode "normal"

        on_force_close "quit"
        pane_frames true
        pane_viewport_serialization true
        scrollback_lines_to_serialize 1000
        session_serialization true
        theme "tokyo-night-dark"

        ui {
          pane_frames {
            hide_session_name true
            rounded_corners true
          }
        }
      '';
  };
}
