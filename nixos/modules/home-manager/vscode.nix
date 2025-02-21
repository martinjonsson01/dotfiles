{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    vscode.enable = lib.mkEnableOption "Enables Visual Studio Code";
  };

  config = {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide # LSP integration for nix
          kamadorueda.alejandra # Nix formatter
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "syntax-highlight";
            publisher = "peaceshi";
            version = "0.0.15";
            sha256 = "0arsy8jmwnzrhcnyia958flvpiwzy0ngrcmivab7cxwm6dzlw6gw";
          }
        ];
      userSettings = {
        "nix.formatterPath" = "alejandra";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        "security.workspace.trust.untrustedFiles" = "open";

        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;

        "explorer.confirmDelete" = false;

        "git.openRepositoryInParentFolders" = "always";

        "explorer.confirmDragAndDrop" = false;

        "workbench.colorTheme" = "Syntax Material Dark";
      };
    };
  };
}
