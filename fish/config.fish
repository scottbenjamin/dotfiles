fish_add_path ~/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /etc/profiles/per-user/$USER/bin/

if status is-interactive
    # Commands to run in interactive sessions can go here

    if type -q brew
      if test -d (brew --prefix)"/share/fish/completions"
          set -p fish_complete_path (brew --prefix)/share/fish/completions
      end

      if test -d (brew --prefix)"/share/fish/vendor_completions.d"
          set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
      end
    end

    if type -q direnv
      direnv hook fish | source
    end

    if type -q carapace 
      # ~/.config/fish/config.fish
      set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
      carapace _carapace | source
    end

    if type -q atuin
      atuin init fish | source
    end

    if type -q zoxide
      zoxide init fish | source
    end

    starship init fish | source

    if test -f ~/.local.fish
      source ~/.local.fish
    end
end

