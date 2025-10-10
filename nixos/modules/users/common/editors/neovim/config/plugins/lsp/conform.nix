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
        local slow_format_filetypes = {}
        local range_ignore_filetypes = { "lua" }
        vim.g.format_modifications_only = true

        function format_hunks()
        	local hunks = require("gitsigns").get_hunks()
        	if hunks == nil then
        		return
        	end

        	local format = require("conform").format
        	for i = #hunks, 1, -1 do
        		local hunk = hunks[i]
        		if hunk ~= nil and hunk.type ~= "delete" then
        			local start = hunk.added.start
        			local last = start + hunk.added.count
        			-- nvim_buf_get_lines uses zero-based indexing -> subtract from last
        			local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
        			local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
        			format({ range = range, lsp_fallback = true })
        		end
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

              local function on_format(err)
                if err and err:match("timeout$") then
                  slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
              end

              if (vim.g.format_modifications_only or vim.b[bufnr].format_modifications_only) and not vim.tbl_contains(range_ignore_filetypes, vim.bo[bufnr].filetype) then
                format_hunks()
              else
                return { timeout_ms = 200, lsp_fallback = true }, on_format
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

              if (vim.g.format_modifications_only or vim.b[bufnr].format_modifications_only) and not vim.tbl_contains(range_ignore_filetypes, vim.bo[bufnr].filetype) then
                format_hunks()
              else
                return { lsp_fallback = true }
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
            "isort"
          ];
          lua = ["stylua"];
          nix = ["alejandra" "injected"];
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
          clang_format.command = "${lib.getExe' pkgs.clang-tools ''clang-format''}";
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
