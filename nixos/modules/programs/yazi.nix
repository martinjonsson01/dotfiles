#
# Blazing fast terminal file manager written in Rust, based on async I/O
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.eclipse.yazi.enable = mkEnableOption "Enables Yazi";

  config = mkIf config.eclipse.yazi.enable {
    eclipse.hm = {pkgs, ...}: let
      archiveMimeTypes = [
        "application/*zip"
        "application/java-archive"
        "application/vnd.rar"
        "application/x-7z-compressed"
        "application/x-bzip2"
        "application/x-rar"
        "application/x-tar"
        "application/x-xz"
        "application/x-zstd"
        "application/xz"
        "application/zstd"
      ];
    in {
      home.packages = with pkgs; [
        ouch # Command-line utility for easily compressing and decompressing files and directories
        file # Program that shows the type of files
      ];

      programs.yazi = {
        enable = true;
        enableFishIntegration = true; # Change directory when exiting Yazi

        settings = {
          mgr = {
            show_hidden = true;
            sort_dir_first = true;
            prepend_keymap = [
              {
                on = ["C"];
                run = "plugin ouch";
                desc = "Compress with ouch";
              }
            ];
          };

          open.rules =
            [
              {
                mime = "inode/directory";
                use = "fish-dir";
              }
              {
                mime = "*";
                use = "open";
              }
            ]
            ++ (
              map (mime: {
                inherit mime;
                use = "extract";
              })
              archiveMimeTypes
            );

          opener.fish-dir = [
            {
              run = ''${getExe pkgs.fish} -c "cd $1; exec ${getExe pkgs.fish}"'';
              block = true;
              desc = "Open directory in Fish";
            }
          ];
          opener.extract = [
            {
              run = ''${getExe pkgs.ouch} decompress --yes "$@"'';
              desc = "Extract here with ouch";
              for = "unix";
            }
          ];
          opener.open = [
            {
              run = ''${getExe' pkgs.xdg-utils "xdg-open"} "$@"'';
              desc = "Open";
            }
          ];

          plugin.prepend_previewers =
            map (mime: {
              inherit mime;
              run = "ouch";
            })
            archiveMimeTypes;
        };

        plugins = {
          inherit (pkgs.yaziPlugins) ouch;
        };
      };
    };
  };
}
