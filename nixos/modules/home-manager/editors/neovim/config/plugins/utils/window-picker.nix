{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    nvim-window-picker
  ];

  extraConfigLua = ''
    require('window-picker').setup({
      hint = "floating-big-letter",
      autoselect_one = true,
      include_current = false,
      filter_rules = {
        bo = {
          filetype = { 'NvimTree', 'neo-tree', 'notify', 'quickfix' },
          buftype = { 'terminal', 'quickfix' }
        }
      },
      other_win_hl_color = '#e35e4f'
    })
  '';
}
