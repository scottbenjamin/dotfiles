{
  description = "My Darwin system flake";

  inputs = {
    # NixPKGSHH
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # NixDarwin
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Flake utils
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    darwin,
    nix-homebrew,
    home-manager,
  } @ inputs: let
    inherit (self) outputs;
  in {
    darwinConfigurations = {
      "Scotts-MacBook-Pro" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit nixpkgs inputs;};
        modules = [
          ./systems/personal.nix
        ];
      };
    };

    homeConfigurations = {
      "Scotts-MacBook-Pro" = home-manager.lib.homeManagerConfiguration {
        system = "aarch64-darwin";
        extraSpecialArgs = {inherit nixpkgs inputs;}; # homemanager uses extraSpecialArgs instead of specialArgs
        modules = [
          ./home-manager/personal.nix
        ];
      };
    };
  };
}
