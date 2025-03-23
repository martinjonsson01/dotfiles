#
# A monitor of resources (a fancy version of `top`)
#
{
  lib,
  config,
  ...
}: {
  options = {
    btop.enable = lib.mkEnableOption "Enables btop";
  };

  config = lib.mkIf config.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        show_boxes = "proc cpu mem"; # Manually set which boxes to show. Available values are "cpu mem net proc" and "gpu0" through "gpu5", separate values with whitespace.
        update_ms = 200; # Update time in milliseconds, recommended 2000 ms or above for better sample times for graphs.
        proc_per_core = true; # If process cpu usage should be of the core it's running on or usage of the total available cpu power.
        cpu_single_graph = true; # Set to True to completely disable the lower CPU graph.
      };
    };
  };
}
