{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.eclipse.work;
in {
  options.eclipse.work.enable = mkEnableOption "Enables the work profile.";

  config = mkIf cfg.enable {
    # Overrides the personal Git identity for everything under ~/Projects.
    eclipse.hm.home.file."Projects/.gitconfig".text = ''
      [user]
        name = "Martin Jonsson"
        email = "mjonsson@antmicro.com"

      [url "git@github.com-antmicro"]
        insteadOf = git@github.com
    '';
  };
}
