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
              if mon.name == "DP-5"
              then "top"
              else "center"
            },"
            + "default:${strBool (ws == builtins.head mon.workspaces)}"
            + "persistent:true"
        )
        mon.workspaces
    )
    monitors;
in {
  # [ "<ws>, monitor:<name>, default:<bool>" "..." ]
  workspace = mkWorkspaces osConfig.myHardware.monitors;
}
