#
# Movie player for the GNOME desktop based on GStreamer.
#
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    totem.enable = mkEnableOption "Enables Totem";
  };

  config = mkIf config.totem.enable {
    home.packages = with pkgs; [totem];

    home.sessionVariables = {
      # Necessary for Totem's OpenGL support in Wayland (see https://gitlab.gnome.org/GNOME/totem/-/issues/616)
      GDK_GL = "gles";
    };

    programs.niri.settings.window-rules = mkIf config.niri.enable [
      #  Open as floating.
      {
        matches = [
          {app-id = "^totem$";}
        ];
        open-floating = true;
      }
    ];
  };
}
