{
  plugins.mini = {
    enable = true;

    modules = {
      surround = {};
      bufremove = {}; # Keeps windows in place when closing buffer, replacing the buffer inside.
      move = {}; # Move selection while preserving it and reindenting it
      trailspace = {}; # Highlight trailing spaces
    };
  };
}
