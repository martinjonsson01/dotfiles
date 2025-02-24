{
  general = {
    gaps_in = 5;
    gaps_out = 20;
    "col.inactive_border" = "rgb(A9B1D6)";
    "col.active_border" = "rgb(A9B1D6)";
    layout = "master";
  };

  decoration = {
    rounding = 10;
    inactive_opacity = 0.7;
    dim_inactive = true;
    dim_strength = 0.3;
  };

  master = {
    new_on_top = true; # whether a newly open window should be on the top of the stack
    mfact = 0.45; # the size as a percentage of the master window, for example mfact = 0.70 would mean 70% of the screen will be the master window, and 30% the slave
    allow_small_split = true; # enable adding additional master windows in a horizontal split style
  };
}
