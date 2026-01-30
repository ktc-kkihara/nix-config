{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Prompt format
      format = ''
        $username$hostname$directory$git_branch$git_status$git_state$fill$cmd_duration$line_break$character
      '';

      # Right prompt
      right_format = ''
        $nodejs$go$rust$java$terraform$aws$docker_context$nix_shell
      '';

      # Add a blank line before the prompt
      add_newline = true;

      # Fill character between left and right prompt
      fill = {
        symbol = " ";
      };

      # Character prompt
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      # Directory
      directory = {
        truncation_length = 5;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold cyan";
        read_only = " 󰌾";
      };

      # Git branch
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        style = "bold purple";
      };

      # Git status
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "*\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };

      # Git state (rebase, merge, etc.)
      git_state = {
        format = "[$state( $progress_current/$progress_total)]($style) ";
        style = "bold yellow";
        rebase = "REBASING";
        merge = "MERGING";
        revert = "REVERTING";
        cherry_pick = "CHERRY-PICKING";
        bisect = "BISECTING";
        am = "AM";
        am_or_rebase = "AM/REBASE";
      };

      # Command duration
      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "bold yellow";
        show_milliseconds = false;
      };

      # Username
      username = {
        format = "[$user]($style)@";
        style_user = "bold blue";
        show_always = false;
      };

      # Hostname
      hostname = {
        format = "[$hostname]($style) ";
        style = "bold green";
        ssh_only = true;
      };

      # Node.js
      nodejs = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold green";
        detect_files = [ "package.json" ".node-version" ];
        detect_folders = [ "node_modules" ];
      };

      # Go
      golang = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold cyan";
      };

      # Rust
      rust = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold red";
      };

      # Java
      java = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold red";
        detect_files = [ "pom.xml" "build.gradle" "build.gradle.kts" ".java-version" ];
      };

      # Terraform
      terraform = {
        format = "[$symbol$workspace]($style) ";
        symbol = "󱁢 ";
        style = "bold purple";
      };

      # AWS
      aws = {
        format = "[$symbol($profile)(\\($region\\))]($style) ";
        symbol = " ";
        style = "bold orange";
      };

      # Docker
      docker_context = {
        format = "[$symbol$context]($style) ";
        symbol = " ";
        style = "bold blue";
        only_with_files = true;
      };

      # Nix shell
      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = " ";
        style = "bold blue";
        impure_msg = "";
        pure_msg = "pure";
      };

      # Package version (disabled - too slow)
      package.disabled = true;
    };
  };
}
