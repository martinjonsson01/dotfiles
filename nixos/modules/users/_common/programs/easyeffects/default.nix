#
# Audio effects for PipeWire applications.
#
{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    easyeffects.enable = mkEnableOption "Enables easyeffects";
  };

  config = mkIf config.easyeffects.enable {
    services.easyeffects = {
      enable = true;
    };

    xdg.dataFile = {
      "easyeffects/input/voice-chat.json".source = ./voice-chat.json;
      "easyeffects/autoload/input/NoiseTorch Microphone for Elgato Wave:3:.json".source =
        ./voice-chat-autoload.json;
    };
  };
}
