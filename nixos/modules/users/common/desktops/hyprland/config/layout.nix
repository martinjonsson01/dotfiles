{
  general = {
    layout = "hy3";
  };

  master = {
    new_status = "master";
    new_on_top = true; # whether a newly open window should be on the top of the stack
    mfact = 0.45; # the size as a percentage of the master window, for example mfact = 0.70 would mean 70% of the screen will be the master window, and 30% the slave
    allow_small_split = true; # enable adding additional master windows in a horizontal split style
    always_center_master = true;
  };

  plugin = {
    hy3 = {
      tabs = {
        border_width = 1;
        col.active = "rgba(33ccff20)";
        col.border.active = "rgba(33ccffee)";
        col.text.active = "rgba(ffffffff)";
        col.inactive = "rgba(30303020)";
        col.border.inactive = "rgba(595959aa)";
      };
      autotile = {
        enable = true;
        trigger_width = 800;
        trigger_height = 500;
      };
    };
  };
}
