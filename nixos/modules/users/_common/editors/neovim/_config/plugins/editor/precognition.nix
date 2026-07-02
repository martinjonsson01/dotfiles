{
  lib,
  config,
  ...
}:
with lib; {
  plugins.precognition = {
    enable = false;

    settings.startVisible = true;
  };

  keymaps = mkIf config.plugins.precognition.enable [
    {
      mode = "n";
      key = "<leader>vp";
      action.__raw = ''
        function()
          local toggled = vim.cmd("Precognition toggle")
          if toggled then
              vim.notify("Precognition on")
          else
              vim.notify("Precognition off")
          end
        end
      '';

      options = {
        desc = "Precognition Toggle";
        silent = true;
      };
    }
  ];
}
