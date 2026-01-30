{ pkgs, ... }:

{
  # Neovim configuration
  # Note: We only manage the Neovim package and external dependencies here
  # The actual config is in ~/.config/nvim and is managed separately
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Don't manage plugins or configuration here
    # Use your existing ~/.config/nvim setup
  };

  # External dependencies for LSP servers and tools
  # These are typically used by Mason or lazy.nvim
  home.packages = with pkgs; [
    # Language servers
    lua-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
    gopls
    rust-analyzer
    terraform-ls
    yaml-language-server

    # Formatters
    stylua
    nodePackages.prettier
    shfmt
    nixfmt

    # Linters
    shellcheck
    actionlint
    hadolint

    # Debug adapters
    delve  # Go debugger

    # Build tools for tree-sitter
    tree-sitter
    gcc
  ];
}
