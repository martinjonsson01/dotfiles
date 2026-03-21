{...}: {
  # https://nvimdev.github.io/lspsaga/
  plugins.lspsaga = {
    enable = true;

    settings = {
      codeAction = {
        onlyInCursor = false;
        showServerName = true;
        extendGitSigns = false; # this is noise
      };

      outline = {
        detail = true;
        winWidth = 50;
      };

      ui.codeAction = "󰌶";
      lightbulb.sign = false;
      lightbulb.debounce = 200;
    };
  };
}
