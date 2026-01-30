{ pkgs, hostname, username, ... }:

{
  imports = [
    ./homebrew.nix
    ./system.nix
  ];

  # Primary user (required for user-specific options)
  system.primaryUser = username;

  # Nix configuration
  nix = {
    settings = {
      # Enable flakes and new nix command
      experimental-features = [ "nix-command" "flakes" ];

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      # Trusted users
      trusted-users = [ "root" username ];
    };

    # Garbage collection
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages (minimal - most go in home-manager)
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;

  # Set hostname
  networking.hostName = hostname;

  # Used for backwards compatibility
  system.stateVersion = 5;

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";
}
