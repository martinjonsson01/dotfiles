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

    settings = {
      close_if_last_window = true;
      filesystem = {
        filtered_items = {
          visible = true;
          hide_dotfiles = false;
          hide_gitignored = false;
          hide_hidden = false;
        };
        follow_current_file.enabled = true;
      };
      event_handlers = [
        {
          event = "file_moved";
          handler.__raw = ''
            function(data)
              Snacks.rename.on_rename_file(data.source, data.destination)
            end
          '';
        }
        {
          event = "file_renamed";
          handler.__raw = ''
            function(data)
              Snacks.rename.on_rename_file(data.source, data.destination)
            end
          '';
        }
        {
          event = "file_open_requested";
          handler.__raw = ''
            function(file_path)
              require("neo-tree.command").execute({ action = "close" })
            end
          '';
        }
      ];
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
}
