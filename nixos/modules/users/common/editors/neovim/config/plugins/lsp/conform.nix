{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    extraConfigLuaPre =
      # lua
      ''
        local slow_format_filetypes = { robot = true }
        local use_lsp_fallback_filetypes = { robot = false }
        local range_ignore_filetypes = { "lua" }
        vim.g.format_modifications_only = true

        function format_hunks(on_format)
        	local hunks = require("gitsigns").get_hunks()
        	if hunks == nil then
        		return
        	end

        	local format_args = {}
        	for i = #hunks, 1, -1 do
        		local hunk = hunks[i]
        		if hunk ~= nil and hunk.type ~= "delete" then
        			local start = hunk.added.start
        			local last = start + hunk.added.count
        			local ok, result = pcall(function()
        				-- nvim_buf_get_lines uses zero-based indexing -> subtract from last
        				return vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
        			end)
        			if not ok then
        				vim.notify("unable to format hunks due to error: " .. result)
        				return
        			end
        			local last_hunk_line = result
        			local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
        			local args = { range = range, lsp_fallback = false }
        			table.insert(format_args, args)
        		end
        	end

        	vim.notify("format_hunks")
        	local format = require("conform").format
        	for _, args in ipairs(format_args) do
        		if on_format ~= nil then
        			args["timeout_ms"] = 5
        		end
        		format(args, on_format)
        	end
        end
      '';
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save =
          # lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              function on_format(err)
                if err and err:match("timeout$") then
                  local filetype = vim.bo[bufnr].filetype
                  vim.notify("format timeout for file type " .. filetype)
                  slow_format_filetypes[filetype] = true
                end
              end

                 local filetype = vim.bo[bufnr].filetype
                 if vim.g.format_modifications_only and vim.b[bufnr].format_modifications_only and (not vim.tbl_contains(range_ignore_filetypes, filetype)) then
                   vim.notify("calling format_hunks in format_on_save")
                   format_hunks(on_format)
                 else
                   vim.notify("format_on_save")
                   local use_lsp_fallback = use_lsp_fallback_filetypes[filetype] or true
                   return { timeout_ms = 200, lsp_fallback = use_lsp_fallback }, on_format
                 end
               end
          '';

        format_after_save =
          #lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              local filetype = vim.bo[bufnr].filetype
              if vim.g.format_modifications_only and vim.b[bufnr].format_modifications_only and (not vim.tbl_contains(range_ignore_filetypes, filetype)) then
                vim.notify("calling format_hunks in format_after_save")
                format_hunks(nil)
              else
                local use_lsp_fallback = use_lsp_fallback_filetypes[filetype] or true
                vim.notify("format_after_save")
                return { lsp_fallback = use_lsp_fallback }
              end
            end
          '';
        notify_on_error = true;
        formatters_by_ft = {
          html = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          css = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          typescript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          python = [
            "black"
          ];
          lua = ["stylua"];
          nix = [
            "alejandra"
            "injected"
          ];
          markdown = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          yaml = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          terraform = ["terraform_fmt"];
          bicep = ["bicep"];
          bash = [
            "shellcheck"
            "shfmt"
          ];
          # Neovim sets the filetype as sh rather than bash for bash files...
          sh = [
            "shellcheck"
            "shfmt"
          ];
          json = ["jq"];
          rust = ["rustfmt"];
          c = ["clang_format"];
          cmake = ["cmake-format"];
          robot = ["robotidy"];
          "_" = ["trim_whitespace"];
        };

        formatters = {
          black.command = "${lib.getExe pkgs.black}";
          isort.command = "${lib.getExe pkgs.isort}";
          nixfmt-rfc-style.command = "${lib.getExe pkgs.nixfmt-rfc-style}";
          alejandra.command = "${lib.getExe pkgs.alejandra}";
          jq.command = "${lib.getExe pkgs.jq}";
          prettierd.command = "${lib.getExe pkgs.prettierd}";
          stylua.command = "${lib.getExe pkgs.stylua}";
          shellcheck.command = "${lib.getExe pkgs.shellcheck}";
          shfmt.command = "${lib.getExe pkgs.shfmt}";
          shellharden.command = "${lib.getExe pkgs.shellharden}";
          bicep.command = "${lib.getExe pkgs.bicep}";
          rustfmt.command = "${lib.getExe pkgs.rustfmt}";
          clang_format.command = "${lib.getExe' pkgs.clang-tools "clang-format"}";
          cmake-format.command = "${lib.getExe pkgs.cmake-format}";
          robotidy = {
            command = "${lib.getExe pkgs.robotframework-tidy}";
            args = [
              "--config"
              "${config.xdg.configHome}/fish/functions/utils/robotidy-config.toml"
              "$FILENAME"
            ];
            stdin = false; # robotidy wants to modify the file in-place
          };
          injected = {
            options = {
              ignore_errors = true; # Partial code snippets can break formatters.
            };
          };
        };
      };
    };
  };
}
