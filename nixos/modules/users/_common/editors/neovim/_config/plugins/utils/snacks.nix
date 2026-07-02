{
  plugins.snacks = {
    enable = true;
  };

  keymaps = [
    {
      mode = ["n"];
      key = "grf";
      action.__raw = "Snacks.rename.rename_file";
      options = {
        desc = "Rename current buffer's file";
      };
    }
  ];
}
