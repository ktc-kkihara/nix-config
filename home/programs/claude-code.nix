# Claude Code CLI
# Installed via official native installer (not npm)
# https://claude.ai/install.sh
#
# This installs to ~/.claude/bin/claude and auto-updates in the background.

{ pkgs, lib, ... }:

{
  # Install Claude Code via official installer during activation
  home.activation.installClaudeCode = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Only install if not already installed
    if ! [ -x "$HOME/.claude/bin/claude" ]; then
      echo "Installing Claude Code via native installer..."
      ${pkgs.curl}/bin/curl -fsSL https://claude.ai/install.sh | ${pkgs.bash}/bin/bash
    fi
  '';

  # Add Claude Code bin to PATH
  home.sessionPath = [
    "$HOME/.claude/bin"
  ];
}
