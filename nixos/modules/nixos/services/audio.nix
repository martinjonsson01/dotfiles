{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    audio.enable = lib.mkEnableOption "Enables audio";
  };

  config = lib.mkIf config.audio.enable {
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
              ${lib.strings.concatMapStrings (matchRule: ''
                { ${matchRule} }
              '')
              config.myHardware.audio.disabledMatches}
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
              ${lib.strings.concatImapStringsSep "\n" (index: matchRule: ''
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
              config.myHardware.audio.sinkPriorityMatches}
            ]
          '')
        ];
      };
    };
  };
}
