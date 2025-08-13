{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    vim-unimpaired
  ];
}
