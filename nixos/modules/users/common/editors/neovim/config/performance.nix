{
  performance = {
    byteCompileLua = {
      enable = false; # Enabling seems to break telescope :( (maybe only one part needs disabling?)
      configs = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
  };
}
