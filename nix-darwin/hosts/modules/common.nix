# # common.nix
# {
#   config,
#   pkgs,
#   lib,
#   additionalHomebrewCasks ? [],
#   ...
# }: let
#   systemPackages = with pkgs; [
#     coreutils
#     _1password-cli
#     alejandra
#     atuin
#     readlink
#     awscli2
#     bat
#     delta
#     direnv
#     du-dust
#     mkalias
#     fd
#     git
#     jq
#     k3d
#     k9s
#     kubectl
#     lazydocker
#     mkalias
#     nushell
#     pre-commit
#     pyenv
#     ripgrep
#     rustup
#     starship
#     tenv
#     zoxide
#   ];
# in {
#   # How do I import a module here?
#   options = {
#     username = lib.mkOption {
#       type = lib.types.str;
#       description = "The username for Homebrew installation.";
#     };
#
#     additionalHomebrewCasks = lib.mkOption {
#       type = lib.types.listOf lib.types.str;
#       default = [];
#       description = "Additional Homebrew casks to be installed.";
#     };
#   };
#
#   config = {
#     environment.systemPackages = systemPackages;
#     # Fonts
#     fonts.packages = [
#       (pkgs.nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
#     ];
#
#     security.pam.enableSudoTouchIdAuth = true;
#
#     # Alias configurations
#     # system.activationScripts.applications.text = let
#     #   env = pkgs.buildEnv {
#     #     name = "system-applications";
#     #     paths = systemPackages;
#     #     pathsToLink = "/Applications";
#     #   };
#     # in
#     #   pkgs.lib.mkForce ''
#     #     # Set up applications.
#     #     echo "setting up /Applications..." >&2
#     #     rm -rf /Applications/Nix\ Apps
#     #     mkdir -p /Applications/Nix\ Apps
#     #     find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
#     #     while read -r src; do
#     #       app_name=$(basename "$src")
#     #       echo "copying $src" >&2
#     #       ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
#     #     done
#     #   '';
#
#     # Mac OS settings
#     system.defaults = {
#       dock.autohide = true;
#       dock.mru-spaces = false;
#       finder.AppleShowAllExtensions = true;
#       finder.FXPreferredViewStyle = "clmv";
#       loginwindow.LoginwindowText = "Login";
#       screencapture.location = "~/Pictures/screenshots";
#       screensaver.askForPasswordDelay = 10;
#       NSGlobalDomain = {
#         AppleInterfaceStyle = "Dark";
#         KeyRepeat = 2;
#       };
#     };
#
#     # Homebrew settings / config
#     homebrew = {
#       enable = true;
#       onActivation.cleanup = "zap";
#       onActivation.autoUpdate = true;
#       onActivation.upgrade = true;
#       casks = lib.mkMerge [
#         [
#           "1password"
#           "wezterm@nightly"
#           "keymapp"
#           "brave-browser"
#           "docker"
#           "alacritty"
#         ]
#         config.additionalHomebrewCasks
#       ];
#       taps = [
#         "nikitabobko/tap"
#       ];
#     };
#   };
# }
