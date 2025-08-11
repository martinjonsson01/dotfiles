#
# Tool to improve keyboard comfort and usability with advanced customization.
#
{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    kanata.enable = mkEnableOption "Enables Kanata";
  };

  config = mkIf config.kanata.enable {
    services.kanata = {
      enable = true;
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
