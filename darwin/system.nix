{ ... }:

{
  # macOS system configuration
  system = {
    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        show-recents = false;
        mru-spaces = false;
        # Position on screen
        orientation = "bottom";
      };

      # Finder settings
      finder = {
        # Show all file extensions
        AppleShowAllExtensions = true;
        # Show hidden files
        AppleShowAllFiles = true;
        # Show path bar
        ShowPathbar = true;
        # Show status bar
        ShowStatusBar = true;
        # Default to list view
        FXPreferredViewStyle = "Nlsv";
        # Search current folder by default
        FXDefaultSearchScope = "SCcf";
      };

      # Trackpad settings
      trackpad = {
        # Enable tap to click
        Clicking = true;
        # Enable three finger drag
        TrackpadThreeFingerDrag = true;
      };

      # Global settings
      NSGlobalDomain = {
        # Enable full keyboard access for all controls
        AppleKeyboardUIMode = 3;
        # Disable press-and-hold for keys in favor of key repeat
        ApplePressAndHoldEnabled = false;
        # Fast key repeat rate
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        # Always show scrollbars
        AppleShowScrollBars = "Always";
        # Expand save panel by default
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        # Expand print panel by default
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };

      # Login window settings
      loginwindow = {
        # Disable guest account
        GuestEnabled = false;
      };

      # Custom user preferences
      CustomUserPreferences = {
        # Prevent .DS_Store files on network and USB volumes
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      # Remap Caps Lock to Control
      remapCapsLockToControl = true;
    };
  };

  # Security settings - Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
