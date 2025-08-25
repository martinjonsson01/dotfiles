{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.myHardware = {
    cpu = mkOption {
      type = types.nullOr (
        types.enum [
          "amd"
          "intel"
        ]
      );
      default = null;
    };

    gpuDriver = mkOption {
      type = types.nullOr (
        types.enum [
          "amd"
          "intel"
          "nvidia"
          "nouveau"
        ]
      );
      default = null;
    };

    isUEFI = mkOption {
      type = types.bool;
      default = true;
    };

    monitors = mkOption {
      type = types.listOf (
        types.submodule (
          {config, ...}: {
            options = {
              name = mkOption {type = types.str;};
              connector = mkOption {type = types.str;};
              xname = mkOption {
                type = types.str;
                default = config.name;
                description = ''
                  Name of the monitor on X11 session.
                  `xrandr` doesn't use the name reported in `/sys/class/drm`, it's also different depending on graphic driver.
                '';
              };
              primary = mkOption {
                type = types.bool;
                default = false;
              };
              width = mkOption {
                type = types.int;
                default = 1920;
              };
              height = mkOption {
                type = types.int;
                default = 1080;
              };
              refreshRate = mkOption {
                type = types.float;
                default = 60.0;
              };
              rotation = mkOption {
                type = types.int;
                default = 0;
              };
              x = mkOption {
                type = types.int;
                default = 0;
              };
              y = mkOption {
                type = types.int;
                default = 0;
              };
              wallpaper = mkOption {
                type = types.nullOr types.path;
                default = null;
              };
              workspaces = mkOption {
                type = types.listOf types.int;
                default = [];
              };
            };
          }
        )
      );
      default = [];
    };

    audio = mkOption {
      type = types.submodule (
        {config, ...}: {
          options = {
            # WirePlumber match rules for devices/nodes to disable.
            disabledMatches = mkOption {
              type = types.listOf (types.str);
              default = [];
            };

            # WirePlumber match rules for priority to change which sink is automatically selected.
            # Order determines priority, where first is highest priority.
            sinkPriorityMatches = mkOption {
              type = types.listOf (types.str);
              default = [];
            };
          };
        }
      );
    };
  };

  config = {
    assertions = [
      (
        let
          monitors = config.myHardware.monitors;
          primary = builtins.filter (m: m.primary) monitors;
        in {
          assertion = monitors == [] || builtins.length primary == 1;
          message =
            "Must have exactly one primary monitor in `config.myHardware.monitors` but found "
            + toString (builtins.length primary);
        }
      )
    ];
  };
}
