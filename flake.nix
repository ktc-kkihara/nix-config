{
  description = "KINTO FACTORY Development Environment - Nix Configuration";

  inputs = {
    # Nixpkgs - unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin - macOS system configuration
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager - user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-homebrew - declarative Homebrew management
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # KINTO FACTORY shared Nix configuration
    factory-base = {
      url = "github:ktc-kkihara/factory-nix-base";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew, factory-base }:
    let
      # System configuration
      system = "aarch64-darwin";
      hostname = "P-LMD0551";
      username = "kosuke.kihara";

      # Package configuration
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      # Specialised arguments passed to all modules
      specialArgs = {
        inherit inputs system hostname username factory-base;
      };
    in
    {
      # nix-darwin configuration
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          # nix-homebrew module
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = username;
              autoMigrate = true;
            };
          }

          # Darwin configuration
          ./darwin

          # home-manager module
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${username} = import ./home;
            };
          }
        ];
      };

      # Expose the package set for debugging
      packages.${system}.default = pkgs.hello;

      # Development shell for this repository
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt  # Nix formatter
          nil     # Nix LSP
        ];
      };
    };
}
