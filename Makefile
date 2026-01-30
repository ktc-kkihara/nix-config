# KINTO FACTORY 開発環境 - Nix Configuration Makefile
# Usage: make <target>

.PHONY: help build rebuild update check gc clean fmt edit

# Configuration
HOSTNAME := P-LMD0551
FLAKE_PATH := $(HOME)/ghq/github.com/ktc-kkihara/nix-config

# Default target
.DEFAULT_GOAL := help

## help: Show this help message
help:
	@echo "KINTO FACTORY 開発環境 - Nix Configuration"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed -e 's/## /  /'

## build: Build the configuration without applying
build:
	@echo "Building configuration..."
	nix build "$(FLAKE_PATH)#darwinConfigurations.$(HOSTNAME).system"
	@echo "Build successful! Use 'make rebuild' to apply."

## rebuild: Build and apply the configuration
rebuild:
	@echo "Rebuilding and applying configuration..."
	darwin-rebuild switch --flake "$(FLAKE_PATH)#$(HOSTNAME)"
	@echo "Done!"

## rebuild-debug: Rebuild with debug output
rebuild-debug:
	@echo "Rebuilding with debug output..."
	darwin-rebuild switch --flake "$(FLAKE_PATH)#$(HOSTNAME)" --show-trace

## update: Update all flake inputs
update:
	@echo "Updating flake inputs..."
	nix flake update "$(FLAKE_PATH)"
	@echo "Inputs updated! Run 'make rebuild' to apply."

## update-input: Update a specific flake input (usage: make update-input INPUT=nixpkgs)
update-input:
ifndef INPUT
	@echo "Usage: make update-input INPUT=<input-name>"
	@echo "Available inputs: nixpkgs, nix-darwin, home-manager, nix-homebrew"
else
	@echo "Updating $(INPUT)..."
	nix flake lock "$(FLAKE_PATH)" --update-input $(INPUT)
	@echo "$(INPUT) updated! Run 'make rebuild' to apply."
endif

## check: Run flake check
check:
	@echo "Running flake check..."
	nix flake check "$(FLAKE_PATH)"

## gc: Run garbage collection
gc:
	@echo "Running garbage collection..."
	nix-collect-garbage -d
	@echo "Garbage collection complete!"

## gc-old: Delete generations older than 30 days
gc-old:
	@echo "Deleting generations older than 30 days..."
	nix-collect-garbage --delete-older-than 30d
	@echo "Done!"

## clean: Remove result symlink
clean:
	@echo "Cleaning up..."
	rm -rf result
	@echo "Done!"

## fmt: Format all Nix files
fmt:
	@echo "Formatting Nix files..."
	find "$(FLAKE_PATH)" -name "*.nix" -exec nixfmt {} \;
	@echo "Done!"

## edit: Open configuration in editor
edit:
	@echo "Opening configuration in editor..."
	$(EDITOR) "$(FLAKE_PATH)"

## search: Search for a package in nixpkgs (usage: make search PKG=nodejs)
search:
ifndef PKG
	@echo "Usage: make search PKG=<package-name>"
else
	nix search nixpkgs $(PKG)
endif

## show: Show flake info
show:
	nix flake show "$(FLAKE_PATH)"

## diff: Show what would change
diff:
	@echo "Showing what would change..."
	darwin-rebuild build --flake "$(FLAKE_PATH)#$(HOSTNAME)"
	nix store diff-closures /run/current-system ./result

## history: Show system generations
history:
	darwin-rebuild --list-generations

## rollback: Rollback to previous generation
rollback:
	@echo "Rolling back to previous generation..."
	darwin-rebuild --rollback
	@echo "Done! You may need to restart your shell."
