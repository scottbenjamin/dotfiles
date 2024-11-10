{
  description = "My Nix/Nix-Darwin systems";

  inputs = {
    # NixPkg
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake utils
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    darwin,
    flake-utils,
    home-manager,
    nix-homebrew,
    nixpkgs,
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
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
        };
        modules = [
          ./home/${username}/${hostname}.nix
        ];
      };
  in {
    # Nixos configs
    nixosConfigurations = {};

    darwinConfigurations = {
      "Scotts-MacBook-Pro" = mkDarwinConfiguration "Scotts-MacBook-Pro" "scottbenjamin";
      "WORKHERE" = mkDarwinConfiguration "WORKHERE" "sbenjamin";
    };

    homeConfigurations = {
      "scottbenjamin@Scotts-MacBook-Pro" = mkHomeConfiguration "aarch64-darwin" "scottbenjamin" "Scotts-MacBook-Pro";
      "sbenjamin@WORKHERE" = mkHomeConfiguration "aarch64-darwin" "sbenjamin" "WORKHERE";
    };
    overlays = import ./overlays {inherit inputs;};
  };
}
