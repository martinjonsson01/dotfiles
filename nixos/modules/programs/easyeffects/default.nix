#
# Audio effects for PipeWire applications.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.easyeffects.enable = mkEnableOption "easyeffects";

  config = mkIf config.eclipse.easyeffects.enable {
    eclipse.hm = {
      services.easyeffects = {
        enable = true;
      };

      xdg.dataFile = {
        "easyeffects/input/voice-chat.json".source = ./voice-chat.json;
        "easyeffects/autoload/input/NoiseTorch Microphone for Elgato Wave:3:.json".source =
          ./voice-chat-autoload.json;
      };
    };
  };
}
