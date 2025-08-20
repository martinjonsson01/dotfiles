{
  imports = [
    # General Configuration
    ./settings.nix
    ./keymaps.nix
    ./auto_cmds.nix
    ./file_types.nix
    ./file_type_plugins.nix

    # Themes
    ./plugins/themes

    # Completion
    ./plugins/cmp/cmp.nix
    ./plugins/cmp/lspkind.nix
    ./plugins/cmp/autopairs.nix
    ./plugins/cmp/schemastore.nix

    # Snippets
    ./plugins/snippets/luasnip.nix

    # Editor plugins and configurations
    ./plugins/editor/neo-tree.nix
    ./plugins/editor/treesitter.nix
    ./plugins/editor/undotree.nix
    ./plugins/editor/illuminate.nix
    ./plugins/editor/scope.nix
    ./plugins/editor/todo-comments.nix
    ./plugins/editor/navic.nix
    ./plugins/editor/unimpaired.nix
    ./plugins/editor/code-action.nix
    ./plugins/editor/precognition.nix

    # UI plugins
    ./plugins/ui/lualine.nix
    ./plugins/ui/startup.nix
    ./plugins/ui/statusline.nix
    ./plugins/ui/context.nix

    # LSP and formatting
    ./plugins/lsp/lsp.nix
    ./plugins/lsp/conform.nix
    ./plugins/lsp/fidget.nix

    # Git
    ./plugins/git/lazygit.nix
    ./plugins/git/gitsigns.nix

    # Utils
    ./plugins/utils/telescope.nix
    ./plugins/utils/whichkey.nix
    ./plugins/utils/extra_plugins.nix
    ./plugins/utils/mini.nix
    ./plugins/utils/markdown-preview.nix
    ./plugins/utils/obsidian.nix
    ./plugins/utils/toggleterm.nix
    ./plugins/utils/web-devicons.nix
    ./plugins/utils/window-picker.nix
    ./plugins/utils/auto-session.nix
    ./plugins/utils/sops.nix
    ./plugins/utils/trouble.nix
    ./plugins/utils/snacks.nix
    ./plugins/utils/colorizer.nix
  ];
}
