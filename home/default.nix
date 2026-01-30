{ pkgs, lib, ... }:

let
  # Hardcode username to avoid issues with dots in usernames
  username = "kosuke.kihara";
in
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./programs/neovim.nix
    ./programs/starship.nix
    ./programs/fzf.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    inherit username;
    # Use mkForce to override the null value from home-manager's darwin module
    homeDirectory = lib.mkForce "/Users/${username}";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    stateVersion = "24.05";

    # Environment variables
    sessionVariables = {
      # Editor
      EDITOR = "nvim";
      VISUAL = "nvim";

      # Java
      JAVA_HOME = "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home";

      # Go
      GOPATH = "$HOME/go";
      GOBIN = "$HOME/go/bin";

      # Rust
      CARGO_HOME = "$HOME/.cargo";

      # ghq
      GHQ_ROOT = "$HOME/ghq";

      # Language
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";

      # Less
      LESS = "-R";

      # Docker
      DOCKER_BUILDKIT = "1";
      COMPOSE_DOCKER_CLI_BUILD = "1";
    };

    # Additional PATH entries
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
      "$HOME/.cargo/bin"
      "/opt/homebrew/opt/mysql-client/bin"
    ];
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Enable direnv for per-project environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
