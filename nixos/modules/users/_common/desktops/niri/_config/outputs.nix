{
  lib,
  myHardware,
}: let
  inherit
    (lib)
    mod
    ;
in {
  outputs = builtins.listToAttrs (map ({
      name,
      width,
      height,
      refreshRate,
      primary,
      rotation,
      x,
      y,
      ...
    }: {
      name = name;

      value = {
        mode = {
          width = width;
          height = height;
          # refresh = refreshRate; Omit to use highest available.
        };

        position = {
          x = x;
          y = y;
        };

        transform = {
          rotation = mod (rotation * 90) 360;
        };

        focus-at-startup = primary;
      };
    })
    myHardware.monitors);
}
