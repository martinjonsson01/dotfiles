#
# NOTE: This is NOT the main fish configuration. This is just
# nixos-stuff that can't be done in home-manager.
#
{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    fish.enable = lib.mkEnableOption "Enables fish";
  };

  config = lib.mkIf config.fish.enable {
    # Enable vendor fish completions provided by Nixpkgs
    programs.fish.enable = true;

    # Since fish isn't POSIX compliant, we can't use it as a
    # login shell. Instead, launch it from within bash.
    programs.bash = {
      # Launches fish
      interactiveShellInit = ''
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      '';
    };

    # The minimal, blazing-fast, and infinitely customizable prompt for any shell!
    programs.starship = {
      enable = true;

      settings = {
        aws.disabled = true;
        gcloud.disabled = true;
        kubernetes.disabled = false;
        python.disabled = true;
        ruby.disabled = true;

        git_branch.style = "242";

        directory.style = "blue";
        directory.truncate_to_repo = false;
        directory.truncation_length = 8;

        hostname.ssh_only = false;
        hostname.style = "bold green";
      };
    };
  };
}
