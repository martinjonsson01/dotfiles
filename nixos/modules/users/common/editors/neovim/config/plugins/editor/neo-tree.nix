{
  plugins.neo-tree = {
    enable = true;
    sources = [
      "filesystem"
      "buffers"
      "git_status"
      "document_symbols"
    ];
    addBlankLineAtTop = false;

    filesystem = {
      bindToCwd = false;
      followCurrentFile = {
        enabled = true;
      };
    };

    defaultComponentConfigs = {
      indent = {
        withExpanders = true;
        expanderCollapsed = "󰅂";
        expanderExpanded = "󰅀";
        expanderHighlight = "NeoTreeExpander";
      };

      gitStatus = {
        symbols = {
          added = " ";
          conflict = "󰩌 ";
          deleted = "󱂥";
          ignored = " ";
          modified = " ";
          renamed = "󰑕";
          staged = "󰩍";
          unstaged = "";
          untracked = " ";
        };
      };
    };

    settings.event_handlers = {
      file_moved.__raw =
        #lua
        ''
          function(data)
          	Snacks.rename.on_rename_file(data.source, data.destination)
          end
        '';
      file_renamed.__raw =
        #lua
        ''
          function(data)
            Snacks.rename.on_rename_file(data.source, data.destination)
          end
        '';
      file_opened.__raw =
        #lua
        ''
          function(file_path)
            require("neo-tree").close_all()
          end
        '';
    };
  };

  keymaps = [
    {
      mode = ["n"];
      key = "<leader>e";
      action = "<cmd>Neotree toggle<cr>";
      options = {
        desc = "Open/Close Neotree";
      };
    }
  ];

  extraConfigLua = ''
  
'';
}
