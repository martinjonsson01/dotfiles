#
# pasystray allows setting the default PulseAudio source/sink
# and moving streams on the fly between sources/sinks
# without restarting the client applications.
#
{
  config,
  lib,
  ...
}: {
  options = {
    pasystray.enable = lib.mkEnableOption "Enables PulseAudio System Tray";
  };

  config = lib.mkIf config.pasystray.enable {
    services.pasystray.enable = true;
  };
}
