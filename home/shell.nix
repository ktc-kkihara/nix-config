{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # History configuration
    history = {
      size = 100000;
      save = 100000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    # Shell aliases
    shellAliases = {
      # Nix
      rebuild = "darwin-rebuild switch --flake ~/ghq/github.com/ktc-kkihara/nix-config";
      rebuild-debug = "darwin-rebuild switch --flake ~/ghq/github.com/ktc-kkihara/nix-config --show-trace";
      nix-update = "nix flake update ~/ghq/github.com/ktc-kkihara/nix-config";
      nix-gc = "nix-collect-garbage -d";
      nix-search = "nix search nixpkgs";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # ghq + fzf
      cdp = "cd $(ghq root)/$(ghq list | fzf --preview 'bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.md 2>/dev/null || ls -la $(ghq root)/{}')";

      # Git
      g = "git";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gf = "git fetch";
      gl = "git log --oneline --graph";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gsw = "git switch";
      gworktree = "git worktree";

      # TUI Tools
      lg = "lazygit";
      ld = "lazydocker";

      # Modern replacements
      ls = "eza --icons";
      ll = "eza -la --icons --git";
      lt = "eza --tree --icons";
      cat = "bat";

      # Editors
      v = "nvim";
      vim = "nvim";

      # Docker
      d = "docker";
      dc = "docker compose";
      dps = "docker ps";
      dpa = "docker ps -a";

      # Gradle (KINTO FACTORY)
      gw = "./gradlew";
      gwb = "./gradlew bootRun";
      gwc = "./gradlew clean";
      gwt = "./gradlew test";

      # Misc
      reload = "source ~/.zshrc";
      path = "echo $PATH | tr ':' '\\n'";
      myip = "curl -s ifconfig.me";
    };

    # Additional zsh configuration
    initContent = ''
      # Key bindings
      bindkey -e  # Emacs keybindings
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey '^P' history-search-backward
      bindkey '^N' history-search-forward

      # Edit command line in editor
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey '^X^E' edit-command-line

      # Better word deletion
      autoload -U select-word-style
      select-word-style bash

      # Initialize zoxide
      eval "$(zoxide init zsh)"

      # ghq + fzf with Ctrl+G
      function ghq-fzf() {
        local selected_dir=$(ghq list | fzf --query="$LBUFFER" --preview 'bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.md 2>/dev/null || ls -la $(ghq root)/{}')
        if [ -n "$selected_dir" ]; then
          BUFFER="cd $(ghq root)/$selected_dir"
          zle accept-line
        fi
        zle reset-prompt
      }
      zle -N ghq-fzf
      bindkey '^G' ghq-fzf

      # fzf history search with Ctrl+R (enhanced)
      function fzf-history() {
        local selected=$(history -n 1 | fzf --tac --query="$LBUFFER")
        if [ -n "$selected" ]; then
          BUFFER="$selected"
          CURSOR=$#BUFFER
        fi
        zle reset-prompt
      }
      zle -N fzf-history
      bindkey '^R' fzf-history
    '';

    # Environment variables specific to zsh
    sessionVariables = {
      # Prevent Homebrew from auto-updating every time
      HOMEBREW_NO_AUTO_UPDATE = "1";
    };
  };
}
