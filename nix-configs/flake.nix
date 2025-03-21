{
  description = "My Nix/Nix-Darwin systems";

  inputs = {
    # NixPkg
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixDarwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew = {
      # url = "github:zhaofengli-wip/nix-homebrew";
      url = "git+https://github.com/zhaofengli/nix-homebrew?ref=refs/pull/71/merge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix -- https://stylix.danth.me/index.html
    stylix = {
      url = "github:danth/stylix";
    };
  };

  outputs = {
    self,
    darwin,
    home-manager,
    nix-homebrew,
    # nixpkgs,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    users = {
      scottbenjamin = {
        name = "scottbenjamin";
        email = "scott.benjamin@gmail.com";
        fullName = "Scott Benjamin";
      };
      scott = {
        name = "scott";
        email = "scott.benjamin@gmail.com";
        fullName = "Scott Benjamin";
      };
      sbenjamin = {
        name = "sbenjamin";
        email = "sbenjamin@absci.com";
        fullName = "Scott Benjamin";
      };
    };

    # Function for nix-darwin system configuration
    mkDarwinConfiguration = hostname: username:
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          stylix.darwinModules.stylix
          {
            home-manager.backupFileExtension = "bak";
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/${username}/${hostname}.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs outputs hostname;
              userConfig = users.${username};
            };
          }
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        # pkgs = import nixpkgs {
        #   inherit system;
        # };
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
          home-manager.backupFileExtension = "bak";
        };
        modules = [
          stylix.homeManagerModules.stylix
          ./home/${username}/${hostname}.nix
        ];
      };
  in {
    darwinConfigurations = {
      "Scotts-MacBook-Pro" = mkDarwinConfiguration "Scotts-MacBook-Pro" "scottbenjamin";
      "M-WQ43L-ASB" = mkDarwinConfiguration "M-WQ43L-ASB" "sbenjamin";
    };

    # Only used for systems that are not NixOS or Nix-Darwin
    # AKA, only nix pkg manager is present
    homeConfigurations = {
      "scott@jericho" = mkHomeConfiguration "x86_64-linux" "scott" "jericho";
      "pod" = mkHomeConfiguration "x86_64-linux" "sbenjamin" "pod";
    };

    overlays = import ./overlays {inherit inputs;};
  };
}
