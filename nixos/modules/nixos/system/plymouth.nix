#
# Boot splash and boot logger.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  theme = "black_hud";
in {
  options = {
    plymouth.enable = mkEnableOption "Enables Plymouth";
  };

  config = mkIf config.plymouth.enable {
    environment.systemPackages = with pkgs; [
      adi1090x-plymouth-themes
    ];

    boot.plymouth = {
      enable = true;
      theme = theme;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {selected_themes = [theme];})
      ];
    };
  };
}
