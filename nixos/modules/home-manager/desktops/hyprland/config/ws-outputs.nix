{osConfig}: let
  strBool = b:
    if b
    then "true"
    else "false";
  mkWorkspaces = monitors:
    builtins.concatMap (
      mon:
        builtins.map (
          ws:
            "${toString ws},"
            + "monitor:${mon.name},"
            + "layoutopt:orientation:${
              if mon.rotation == 0
              then "center"
              else "top"
            },"
            + "layoutopt:allow_small_split:${
              if mon.rotation == 0
              then "false"
              else "true"
            },"
            + "default:${strBool (ws == builtins.head mon.workspaces)}"
        )
        mon.workspaces
    )
    monitors;
in {
  # [ "<ws>, monitor:<name>, default:<bool>" "..." ]
  workspace = mkWorkspaces osConfig.myHardware.monitors;
}
