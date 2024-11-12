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
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    home-manager,
    nix-homebrew,
    nixpkgs,
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
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.users.${username} = import ./home/${username}/${hostname}.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs outputs;
              userConfig = users.${username};
            };
          }
        ];
      };

     # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
            home-manager.backupFileExtension = "bak";
        };
        modules = [
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
    };

    overlays = import ./overlays {inherit inputs;};
  };
}