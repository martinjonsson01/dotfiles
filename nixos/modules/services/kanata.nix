#
# Tool to improve keyboard comfort and usability with advanced customization.
#
{
  lib,
  config,
  ...
}:
with lib; {
  options.eclipse.kanata.enable = mkEnableOption "Kanata";

  config = mkIf config.eclipse.kanata.enable {
    services.kanata = {
      enable = true;
      # Rebind caps lock to escape.
      keyboards.Caps2esc.config = ''
        (defsrc
          caps
        )

        (defalias
          escctrl (tap-hold 250 250 esc lctrl)
        )

        (deflayer base
          @escctrl
        )
      '';
    };
  };
}
