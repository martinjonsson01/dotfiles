{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.eclipse.audio.enable = mkEnableOption "Enables audio";

  config = mkIf config.eclipse.audio.enable {
    # Force-unmute Elgato Wave:3 hardware mute on USB connect (capacitive button desync workaround)
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="sound", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0070", RUN+="${pkgs.alsa-utils}/bin/amixer -c Wave3 sset 'Mic Capture Switch' on"
    '';

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;

      wireplumber = {
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-bluetooth-policy.conf" ''
            wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
          '')
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-disable-redundant-sinks.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
              ${concatMapStrings (matchRule: ''
                { ${matchRule} }
              '')
              config.eclipse.hardware.audio.disabledMatches}
                ]
                actions = {
                  update-props = {
                    device.disabled = true
                    node.disabled = true
                  }
                }
              }
            ]
          '')
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-set-sink-priority.conf" ''
            monitor.alsa.rules = [
              ${concatImapStringsSep "\n" (index: matchRule: ''
                {
                  matches = [
                    { ${matchRule} }
                  ]
                  actions = {
                    update-props = {
                      priority.driver = ${toString (2000 - index * 10)}
                      priority.session = ${toString (2000 - index * 10)}
                    }
                  }
                }
              '')
              config.eclipse.hardware.audio.sinkPriorityMatches}
            ]
          '')
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-elgato-wave3.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
                  { node.name = "~alsa_input.usb-Elgato_Systems_Elgato_Wave*" }
                ]
                actions = {
                  update-props = {
                    session.suspend-timeout-seconds = 0
                  }
                }
              }
            ]
          '')
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-noisetorch-no-suspend.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
                  { node.name = "~NoiseTorch*" }
                ]
                actions = {
                  update-props = {
                    session.suspend-timeout-seconds = 0
                  }
                }
              }
            ]
          '')
        ];
      };
    };
  };
}
