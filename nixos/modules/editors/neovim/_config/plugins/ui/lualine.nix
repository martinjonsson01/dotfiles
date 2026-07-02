_: {
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        extensions = [
          "fzf"
          "neo-tree"
        ];
        disabledFiletypes = {
          statusline = [
            "startup"
            "alpha"
          ];
        };
        theme = "tokyonight";
      };
      sections = {
        lualine_a = [
          {
            __unkeyed-1 = "mode";
            icon = "";
          }
        ];
        lualine_b = [
          {
            __unkeyed-1 = "macro";
            fmt = ''
              function()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then
                  return "Recording @" .. reg
                end
                return nil
              end
            '';
            color = {
              fg = "#ff9e64";
            };
            draw_empty = false;
          }
          {
            __unkeyed-1 = "branch";
            icon = "";
          }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "diagnostics";
            sources = ["nvim_lsp"];
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = "󰝶 ";
            };
          }
          {
            __unkeyed-1 = "navic";
          }
        ];
        lualine_x = [
          {
            __unkeyed-1 = "filetype";
            icon_only = false;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          }
        ];
        lualine_y = [
          {
            __unkeyed-1 = "progress";
          }
        ];
        lualine_z = [
          {
            __unkeyed-1 = "location";
          }
          {
            __unkeyed-1.__raw = ''
              function()
                -- Early return when no search highlighting
                if vim.v.hlsearch == 0 then return "" end

                -- Get the last search count without recomputation
                local result = vim.fn.searchcount({ recompute = 1 })

                if not result or vim.tbl_isempty(result) then
                  return ""
                end

                local search_pat = vim.fn.getreg("/")
                if search_pat == "" then
                  return ""
                end

                -- Handle timeouts
                if result.incomplete == 1 then
                  return string.format("%s [?/??]", search_pat)
                end

                -- Handle maxcount exceeded
                if result.incomplete == 2 then
                  local cur = result.current
                  local total = result.total
                  local maxc = result.maxcount

                  if total > maxc and cur > maxc then
                    return string.format("%s [>%d/>%d]", search_pat, cur, total)
                  elseif total > maxc then
                    return string.format("%s [%d/>%d]", search_pat, cur, total)
                  end
                end

                -- Normal display
                return string.format("%s [%d/%d]", search_pat, result.current, result.total)
              end
            '';
          }
        ];
      };
    };
  };
}
