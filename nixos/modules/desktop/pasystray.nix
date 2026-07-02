#
# pasystray allows setting the default PulseAudio source/sink
# and moving streams on the fly between sources/sinks
# without restarting the client applications.
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.pasystray.enable = mkEnableOption "Enables PulseAudio System Tray";

  config = mkIf config.eclipse.pasystray.enable {
    eclipse.hm = {
      services.pasystray.enable = true;
    };
  };
}
