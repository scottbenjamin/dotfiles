{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  username = "scottbenjamin";
in {
  imports = [
    ./common.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # Packages
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [];
  };

  nix-homebrew = {
    enable = true; # Install Homebrew under the default prefix
    user = username;
  };

  additionalHomebrewCasks = [
    "slack"
    "aerospace"
    "raycast"
    # "discord"
  ];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
    };

    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    useDaemon = true;
  };

  # Packages only on this host
  environment.systemPackages = with pkgs; [
    yq
    kind
  ];

  services.aerospace.enable = true;

  system.stateVersion = 5;
}
