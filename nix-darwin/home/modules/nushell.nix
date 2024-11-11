{...}: {
  programs = {
    nushell = {
      enable = true;

      environmentVariables = {
        PAGER = "bat";
      };

      # Extra things to add to the config.nu file
      extraConfig = ''
        def hms [] {
            let h = ^hostname -s
            home-manager switch --flake ~/code/dotfiles/nix-darwin/#($env.USER)@($h)
        }

        def ggg [] {
          git pull --no-rebase
          git fetch --all
        }

        def ec [filename?: string] {
          if ($filename |is-empty) {
            nvim ~/.config/nushell/
          } else {
            nvim ( $env.XDG_CONFIG_HOME | path join nushell $filename)
          }
        }

        def gitlab_token [] {
          echo "GITLAB_TOKEN=$GITLAB_TOKEN"
        }

        # Update Nvim configs by setting XDG_CONFIG_HOME to dotfiles git repo
        def uv [] {
          $env.XDG_CONFIG_HOME = ($nu.home-path | path join code dotfiles)
          print $"Updating nvim configs... using ($env.XDG_CONFIG_HOME)"
          nvim
        }
      '';

      # Extra things to add to the env.nu file
      extraEnv = ''
        use std "path add"
        # $env.PATH = ($env.PATH | split row (char esep))
        # path add /some/path
        # path add ($env.CARGO_HOME | path join "bin")
        # path add ($env.HOME | path join ".local" "bin")
        # $env.PATH = ($env.PATH | uniq)

        # write nushell for loop over a list of paths to append to the path
        path add  /opt/homebrew/bin
        path add  $"($env.HOME)/.nix-profile/bin"
        path add  $"/etc/profiles/per-user/($env.USER)/bin"
        path add  /nix/var/nix/profiles/default/bin
        path add  /run/current-system/sw/bin
        path add  /usr/local/bin
      '';

      shellAliases = {
        e = "nvim";
        ga = "git add";
        gco = "git checkout";
        gfa = "git fetch --all";
        gfm = "git pull --no-rebase";
        gs = "git status";
        k = "kubectl";
        kg = "kubectl get";
        l = "ls";
        la = "ls -al";
        lg = "lazygit";
        ll = "ls -l";
        v = "nvim";
        vim = "nvim";

        drs = "darwin-rebuild switch --flake ~/code/dotfiles/nix-darwin/";
        check = "darwin-rebuild check --flake ~/code/dotfiles/nix-darwin/";
      };
    };
    # Completions
    carapace.enable = true;
    carapace.enableNushellIntegration = true;
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
