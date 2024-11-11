{...}: {
  programs = {
    nushell = {
      enable = true;

      environmentVariables = {
        PAGER = "bat";
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      # Extra things to add to the config.nu file
      extraConfig = ''
        $env.config = {show_banner: false,}
        # Pull without rebase and fetch all
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
        path add  /opt/homebrew/bin
        path add  $"($env.HOME)/.nix-profile/bin"
        path add  $"/etc/profiles/per-user/($env.USER)/bin"
        path add  /nix/var/nix/profiles/default/bin
        path add  /run/current-system/sw/bin
        path add  /usr/local/bin
      '';

      shellAliases = {
        ga = "git add";
        gco = "git checkout";
        gfa = "git fetch --all";
        gfm = "git pull --no-rebase";
        gs = "git status";
        gss = "git status --short";
        k = "kubectl";
        kg = "kubectl get";
        kgp = "kubectl get pods";
        l = "ls";
        la = "ls -al";
        lg = "lazygit";
        ll = "ls -l";
        tg = "terragrunt";
        v = "vim";
        vim = "vim";

        # Nix related
        nsn = "nix search nixpkgs";

        # darwin-build
        drs = "darwin-rebuild switch --flake ~/code/dotfiles/nix-darwin/";
        drc = "darwin-rebuild check --flake ~/code/dotfiles/nix-darwin/";
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
