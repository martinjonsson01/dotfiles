{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    vscode.enable = lib.mkEnableOption "Enables Visual Studio Code";
  };

  config = lib.mkIf config.vscode.enable {
    programs.vscode = {
      enable = true;

      extensions = with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide # LSP integration for nix
          kamadorueda.alejandra # Nix formatter
          bmalehorn.vscode-fish # Fish syntax + formatting
          eamodio.gitlens # Better Git support
          mikestead.dotenv # .env syntax highlighting
          signageos.signageos-vscode-sops # Editing of encrypted files
          editorconfig.editorconfig # Override user settings with .editorconfig
          pkief.material-icon-theme # Icon theme
          gruntfuggly.todo-tree # Show todo items in a tree view
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "syntax-highlight";
            publisher = "peaceshi";
            version = "0.0.15";
            sha256 = "0arsy8jmwnzrhcnyia958flvpiwzy0ngrcmivab7cxwm6dzlw6gw";
          }
          # Tab out of quotes, brackets, etc
          {
            name = "TabOut";
            publisher = "albert";
            version = "0.2.2";
            sha256 = "s306AHMkUFPaG7ISIr0RscK/k6OVtniIG1CQprBx+cY=";
          }
          # A (not so) simple markdown plugin to format tables and other table related features.
          {
            name = "markdown-table-formatter";
            publisher = "fcrespo82";
            version = "3.0.0";
            sha256 = "rUxKfr6mAyHzRtbbozZGYJ8itky3gICSnvnvb3b3PYU=";
          }
          # Allows you to quickly convert one or more selections of text to and from various formats.
          {
            name = "ecdc";
            publisher = "mitchdenny";
            version = "1.8.0";
            sha256 = "W2WlngFC5pAAjkj4lQNR5yPJZiedkjqGZHldjx8m7IU=";
          }
        ];

      userSettings = {
        "nix.formatterPath" = "alejandra";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        "security.workspace.trust.untrustedFiles" = "open";

        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "editor.fontFamily" = "'${config.stylix.fonts.monospace.name}', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontSize" = config.stylix.fonts.sizes.applications + 1;

        "explorer.confirmDelete" = false;

        "git.openRepositoryInParentFolders" = "always";

        "explorer.confirmDragAndDrop" = false;

        "workbench.colorTheme" = "Syntax Material Dark";

        "terminal.integrated.fontSize" = config.stylix.fonts.sizes.terminal + 2;
      };

      keybindings = [
        # Ctrl + Ö terminal
        {
          "key" = "ctrl+[Semicolon]";
          "command" = "workbench.action.terminal.toggleTerminal";
          "when" = "terminal.active";
        }
        {
          "key" = "ctrl+shift+[Equal]";
          "command" = "-workbench.action.terminal.toggleTerminal";
          "when" = "terminal.active";
        }

        # Format document
        {
          "key" = "ctrl+k ctrl+d";
          "command" = "editor.action.formatDocument";
          "when" = "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor";
        }
        {
          "key" = "ctrl+shift+i";
          "command" = "-editor.action.formatDocument";
          "when" = "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor";
        }

        # Delete line
        {
          "key" = "ctrl+shift+l";
          "command" = "editor.action.deleteLines";
          "when" = "textInputFocus && !editorReadonly";
        }
        {
          "key" = "ctrl+shift+k";
          "command" = "-editor.action.deleteLines";
          "when" = "textInputFocus && !editorReadonly";
        }
      ];
    };
  };
}
