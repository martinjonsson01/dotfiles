#
# Collects all module files under a directory, recursively:
# - entries whose name starts with "_" are skipped (helpers/data that other
#   modules import explicitly)
# - a directory containing default.nix is a self-contained bundle: collected
#   as one module, not recursed into
#
let
  collect = dir: let
    entries = builtins.readDir dir;
    visible =
      builtins.filter (name: builtins.substring 0 1 name != "_")
      (builtins.attrNames entries);
    modulesFor = name: let
      path = dir + "/${name}";
    in
      if entries.${name} == "directory"
      then
        if builtins.readDir path ? "default.nix"
        then [path]
        else collect path
      else if builtins.match ".*\\.nix" name != null
      then [path]
      else [];
  in
    builtins.concatMap modulesFor visible;
in
  collect
