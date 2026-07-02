{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  extraPlugins = with pkgs;
    mkIf config.plugins.lz-n.enable [
      vimPlugins.lzn-auto-require
    ];

  extraConfigLuaPost = mkIf config.plugins.lz-n.enable (
    mkOrder 5000 ''
      require('lzn-auto-require').enable()
    ''
  );

  plugins.lz-n.enable = true;
}
