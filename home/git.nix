{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    # Git settings (new format for home-manager)
    settings = {
      # User information
      user = {
        name = "Kosuke Kihara";
        email = "k.kihara@kinto-technologies.com";
      };

      # Default branch name
      init.defaultBranch = "main";

      # Pull behavior
      pull.rebase = true;

      # Push behavior
      push = {
        default = "current";
        autoSetupRemote = true;
      };

      # Fetch behavior
      fetch.prune = true;

      # Rebase behavior
      rebase = {
        autoStash = true;
        autoSquash = true;
      };

      # Merge behavior
      merge.conflictStyle = "zdiff3";

      # Diff behavior
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };

      # Core settings
      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "fix";
        pager = "delta";
      };

      # Delta (better diff viewer)
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
        side-by-side = true;
      };

      # Interactive rebase
      interactive.diffFilter = "delta --color-only";

      # URL shortcuts
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };

      # ghq settings
      ghq.root = "~/ghq";

      # Credential helper for macOS
      credential.helper = "osxkeychain";

      # Color settings
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
        };
        status = {
          added = "green";
          changed = "yellow";
          untracked = "red";
        };
      };

      # Git aliases
      alias = {
        # Status
        s = "status -sb";
        st = "status";

        # Commit
        c = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        can = "commit --amend --no-edit";

        # Branch
        b = "branch";
        ba = "branch -a";
        bd = "branch -d";
        bD = "branch -D";

        # Checkout/Switch
        co = "checkout";
        sw = "switch";
        sc = "switch -c";

        # Diff
        d = "diff";
        ds = "diff --staged";
        dc = "diff --cached";

        # Log
        l = "log --oneline -20";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        ll = "log --stat --abbrev-commit";
        last = "log -1 HEAD --stat";

        # Reset
        unstage = "reset HEAD --";
        undo = "reset --soft HEAD~1";

        # Stash
        ss = "stash save";
        sp = "stash pop";
        sl = "stash list";

        # Worktree
        wt = "worktree";
        wta = "worktree add";
        wtl = "worktree list";
        wtr = "worktree remove";

        # Misc
        aliases = "config --get-regexp alias";
        contributors = "shortlog --summary --numbered";
        fixup = "commit --fixup";
      };
    };

    # Global gitignore
    ignores = [
      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "._*"

      # Editors
      "*.swp"
      "*.swo"
      "*~"
      ".idea/"
      "*.iml"
      ".vscode/"

      # Environment
      ".env"
      ".env.local"
      ".envrc"

      # Build artifacts
      "*.log"
      "*.tmp"
      "*.temp"

      # Nix
      "result"
      "result-*"
    ];
  };

  # GitHub CLI configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
        pl = "pr list";
        pc = "pr create";
        pm = "pr merge";
      };
    };
  };
}
