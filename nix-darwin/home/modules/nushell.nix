{...}: {
  programs = {
    nushell = {
      enable = true;

      configFile.source = ./../../files/nushell/config.nu;
      envFile.source = ./../../files/nushell/env.nu;
      loginFile.source = ./../../files/nushell/login.nu;

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
