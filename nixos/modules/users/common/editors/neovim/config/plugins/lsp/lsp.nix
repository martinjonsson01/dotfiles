{ pkgs, ... }:
{
  plugins = {
    lsp-lines.enable = true;
    lsp-format.enable = true;
    helm.enable = true;
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        nixd = {
          enable = true;
          settings.settings = {
            formatting.command = [ "alejandra" ];
          };
        };
        html.enable = true;
        lua_ls.enable = true;
        nil_ls.enable = true;
        ts_ls.enable = true;
        marksman.enable = true;
        pyright = {
          enable = true;
          extraOptions = {
            before_init = {
              __raw = ''
                function(_, config)
                  local venv = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
                  vim.notify("before_init fired, venv=" .. venv, vim.log.levels.INFO)
                  if venv ~= "" then
                    config.settings = config.settings or {}
                    config.settings.python = config.settings.python or {}
                    config.settings.python.pythonPath = vim.fn.fnamemodify(venv, ":p") .. "bin/python"
                    config.settings.python.defaultInterpreterPath = vim.fn.fnamemodify(venv, ":p") .. "bin/python"
                  end
                end
              '';
            };
          };
        };
        gopls.enable = true;
        terraformls.enable = true;
        jsonls.enable = true;
        fish_lsp.enable = true;
        robotframework_ls = {
          enable = false; # Doesn't work at the moment due to formatter conflict with conform
          package = null; # Installed externally, see below `extraPackages`.
          cmd = [ "robotframework_ls" ];
          filetypes = [ "robot" ];
          extraOptions = {
            settings.robot = {
              formatting.provider = "none";
              timeout.codeFormatting = 0; # Disable LSP formatting (conform uses robotidy already)
            };
          };
        };
        hls = {
          enable = false;
          installGhc = false;
        };
        csharp_ls = {
          enable = true;
          settings = {
            csharp.applyFormattingOptions = true;
          };
        };
        omnisharp = {
          enable = false; # Doesn't follow style conventions for formatting :(
          settings.enableAnalyzersSupport = true;
          settings.enableEditorConfigSupport = true;
        };
        rust_analyzer = {
          enable = true;
          # Installed through per-project flakes instead.
          installCargo = false;
          installRustc = false;

          settings.settings = {
            diagnostics = {
              enable = true;
              styleLints.enable = true;
            };

            files = {
              excludeDirs = [
                ".direnv"
                "rust/.direnv"
              ];
            };

            inlayHints = {
              bindingModeHints.enable = true;
              closureStyle = "rust_analyzer";
              closureReturnTypeHints.enable = "always";
              discriminantHints.enable = "always";
              expressionAdjustmentHints.enable = "always";
              implicitDrops.enable = true;
              lifetimeElisionHints.enable = "always";
              rangeExclusiveHints.enable = true;
            };

            procMacro = {
              enable = true;
            };
          };
        };
        helm_ls = {
          enable = true;
          extraOptions = {
            settings = {
              "helm_ls" = {
                yamlls = {
                  path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
                };
              };
            };
          };
        };
        yamlls = {
          enable = true;
          extraOptions = {
            settings = {
              yaml = {
                format.enable = false;
                schemas = {
                  kubernetes = "'*.yaml";
                  "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
                  "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                  "http://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                  "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                  "http://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                  "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                  "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                    "*docker-compose*.{yml,yaml}";
                  "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" =
                    "*flow*.{yml,yaml}";
                };
              };
            };
          };
        };
        clangd = {
          enable = true;
          settings = {
            settings = {
              init_options = {
                usePlaceholders = true;
                completeUnimported = true;
                clangdFileStatus = true;
              };
            };
            cmd = [
              "clangd"
              "--background-index" # Index project code in the background and persist index on disk.
              "--pretty" # Pretty-print JSON output
              "--clang-tidy" # Enable clang-tidy diagnostics
              "--header-insertion=iwyu" # Include what you use. Insert the owning header for top-level symbols, unless the header is already directly included or the symbol is forward-declared
              "--completion-style=detailed" # One completion item for each semantically distinct completion, with full type information
              "--function-arg-placeholders" # When enabled, completions also contain placeholders for method parameters
              "--fallback-style=llvm" # clang-format style to apply by default when no .clang-format file is found
              "--compile-commands-dir=build" # Specify a path to look for compile_commands.json. If path is invalid, clangd will look in the current directory and parent paths of each source file
            ];
          };
        };
      };

      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
        extra = [
          # Incomming/ Outgoing Definitions
          {
            key = "gCi";
            action = "<cmd>Lspsaga incoming_calls<CR>";
            options.desc = "Goto Calls Icomming";
          }
          {
            key = "gCI";
            action = "<cmd>Lspsaga outgoing_calls<CR>";
            options.desc = "Goto Calls Outgoing";
          }

          # Type & Definition
          {
            key = "gpt";
            action = "<cmd>Lspsaga peek_type_definition<CR>";
            options.desc = "Peek variable Type";
          }
          {
            key = "gpd";
            action = "<cmd>Lspsaga peek_definition<CR>";
            options.desc = "Peek Definition";
          }

          {
            key = "K";
            action = "<cmd>Lspsaga hover_doc<CR>";
            options.desc = "Hover Documentation";
          }
          {
            key = "gh";
            action = "<cmd>Lspsaga hover_doc ++keep<CR>";
            options.desc = "Hover Documentation Keep";
          }

          {
            key = "gn";
            action = "<cmd>Lspsaga rename<CR>";
            options.desc = "Rename";
          }
        ];
      };
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    ansible-vim
  ];

  extraPackages = with pkgs; [
    (python3.withPackages (
      ps:
      with ps;
      let
        robotframework61 = buildPythonPackage rec {
          pname = "robotframework";
          version = "6.1";

          src = fetchFromGitHub {
            owner = "robotframework";
            repo = "robotframework";
            tag = "v${version}";
            sha256 = "sha256-l1VupBKi52UWqJMisT2CVnXph3fGxB63mBVvYdM1NWE=";
          };

          pyproject = true;
          build-system = [ setuptools ];

          doCheck = false;
        };
      in
      [
        psutil
        pyyaml
        robotframework61
        (buildPythonPackage rec {
          pname = "robotframework_lsp";
          version = "1.13.0";

          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-n1JG4x1b2/UrIEm1z6DMSX2Q34fjU6EPQZ0o9B0uGaM=";
          };

          pyproject = true;
          build-system = [ setuptools ];

          propagatedBuildInputs = [
            robotframework61
          ];

          doCheck = false;
        })
      ]
    ))
  ];

  extraConfigLua = ''
    local _border = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    	border = _border,
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    	border = _border,
    })

    vim.diagnostic.config({
    	float = { border = _border },
    })

    require("lspconfig.ui.windows").default_options = {
    	border = _border,
    }
  '';
}
