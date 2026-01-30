{ ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Default command (uses fd for speed)
    defaultCommand = "fd --type f --hidden --follow --exclude .git";

    # Default options
    defaultOptions = [
      "--height 60%"
      "--border"
      "--layout=reverse"
      "--info=inline"
      "--margin=1"
      "--padding=1"
    ];

    # CTRL-T - Paste selected files/directories onto command line
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range :500 {}'"
      "--preview-window=right:60%"
    ];

    # ALT-C - cd into selected directory
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'eza --tree --level=2 --icons {}'"
    ];

    # CTRL-R - Search command history (handled in shell.nix for custom behavior)
    historyWidgetOptions = [
      "--sort"
      "--exact"
    ];

    # Color scheme (Catppuccin Mocha inspired)
    colors = {
      fg = "#cdd6f4";
      "fg+" = "#cdd6f4";
      bg = "#1e1e2e";
      "bg+" = "#313244";
      hl = "#f38ba8";
      "hl+" = "#f38ba8";
      info = "#cba6f7";
      marker = "#f5e0dc";
      prompt = "#cba6f7";
      spinner = "#f5e0dc";
      pointer = "#f5e0dc";
      header = "#f38ba8";
    };
  };
}
