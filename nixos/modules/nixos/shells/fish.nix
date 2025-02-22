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
      # Launches fish unless the parent process is already fish
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };
}
