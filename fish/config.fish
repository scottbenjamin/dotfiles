fish_add_path ~/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /etc/profiles/per-user/$USER/bin/

for p in /run/current-system/sw/bin ~/bin
    if not contains $p $fish_user_paths
        set -g fish_user_paths $p $fish_user_paths
    end
end


if status is-interactive
    # Commands to run in interactive sessions can go here

    if type -q brew
      if test -d (brew --prefix)"/share/fish/completions"
          set -p fish_complete_path (brew --prefix)/share/fish/completions
      end

      if test -d (brew --prefix)"/share/fish/vendor_completions.d"
          set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
      end

      if test -d (brew --prefix rustup )"/bin"
        fish_add_path  (brew --prefix rustup )"/bin"
      end

    end

    if type -q pyenv
      pyenv init - fish | source
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

    if type -q starship
      starship init fish | source
    end

    if test -f ~/.local.fish
      source ~/.local.fish
    end

    function bind_bang
        switch (commandline -t)[-1]
            case "!"
                commandline -t -- $history[1]
                commandline -f repaint
            case "*"
                commandline -i !
        end
    end

    function bind_dollar
        switch (commandline -t)[-1]
            case "!"
                commandline -f backward-delete-char history-token-search-backward
            case "*"
                commandline -i '$'
        end
    end

    function fish_user_key_bindings
        bind ! bind_bang
        bind '$' bind_dollar
    end
end

