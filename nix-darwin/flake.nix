{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs , nix-homebrew}:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = [ 
          # pkgs._1password-gui
          pkgs._1password-cli
          pkgs.alacritty
          pkgs.awscli2
          pkgs.bat
          pkgs.carapace
          pkgs.jq
          pkgs.k9s
          pkgs.kind
          pkgs.kubectl
          pkgs.lazygit
          pkgs.mkalias # Alias apps to Applications folder so spotlight can find it
          pkgs.neovim
          pkgs.nushell
          pkgs.oci-cli
          pkgs.pyenv
          pkgs.starship
          pkgs.tenv
          pkgs.zoxide
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      security.pam.enableSudoTouchIdAuth = true;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Homebrew settings
      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      # Homebrew casks
      homebrew.casks = [
        "keymapp" # Keyboard remapping tool
        "wezterm@nightly"
        "1password"
        "brave-browser"
      ];

      homebrew.brews = [
        "tenv"
      ];

      # Fonts
      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ];})
      ];

      # Alias configurations
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
      '';

      # Mac OS settings
      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = "devops-toolbox";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 10;
      };
    };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mbp
    darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # home-manager.enable = true;
            user = "sbenjamin";
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mbp".pkgs;
  };
}
