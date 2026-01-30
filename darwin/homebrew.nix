{ ... }:

{
  # Homebrew configuration
  # Managed declaratively through nix-darwin
  homebrew = {
    enable = true;

    # Behavior when running `darwin-rebuild switch`
    onActivation = {
      # Remove packages not listed here
      cleanup = "zap";
      # Auto-update Homebrew and packages
      autoUpdate = true;
      # Upgrade outdated packages
      upgrade = true;
    };

    # Homebrew taps
    taps = [
      "homebrew/cask-versions"
    ];

    # Homebrew formulae (CLI tools)
    # Only include packages that have issues with nixpkgs on macOS
    brews = [
      # Amazon Corretto 17 - nixpkgs has build issues on macOS
      "corretto@17"
      # MySQL client - factory-tools compatibility
      "mysql-client"
    ];

    # Homebrew casks (GUI applications)
    casks = [
      # Database GUI
      "dbeaver-community"
      # Terminal emulator
      "wezterm"
      # Docker Desktop
      "docker"
    ];

    # Mac App Store apps (if needed)
    # masApps = {
    #   "App Name" = 123456789;
    # };
  };
}
