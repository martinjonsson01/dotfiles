{myHardware}: {
  workspaces = builtins.listToAttrs (builtins.concatMap (
      monitor:
        builtins.map (
          workspace: {
            name = workspace.name;
            value = {
              open-on-output = monitor.name;
              name = workspace.name;
            };
          }
        )
        monitor.workspaces
    )
    myHardware.monitors);
}
