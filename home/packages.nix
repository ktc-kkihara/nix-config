{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # AWS
    awscli2
    aws-sam-cli

    # Programming Languages & Runtimes
    go
    nodejs_20
    rustup

    # Infrastructure
    terraform

    # gRPC
    grpcurl

    # Data Processing
    jq
    yq-go

    # TUI Tools
    lazydocker
    lazygit

    # Search & Navigation
    ripgrep
    fd
    eza       # modern ls replacement
    bat       # cat with syntax highlighting
    zoxide    # smarter cd

    # Git & GitHub
    gh
    ghq
    delta     # better git diff

    # Shell & Terminal
    coreutils
    gnused
    gnugrep
    findutils

    # Development Tools
    tree
    watch
    htop
    jnv       # JSON viewer
    tokei     # code statistics

    # Network Tools
    curl
    wget
    httpie

    # Nix Tools
    nil       # Nix LSP
    nixfmt    # Nix formatter (was nixfmt-rfc-style)
  ];
}
