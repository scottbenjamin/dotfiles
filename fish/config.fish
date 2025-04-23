fish_add_path ~/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /etc/profiles/per-user/$USER/bin/

if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

if status is-interactive
    # Commands to run in interactive sessions can go here

    direnv hook fish | source
    # ~/.config/fish/config.fish
    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
    carapace _carapace | source

    atuin init fish | source
    zoxide init fish | source

    starship init fish | source

    if test -f ~/.local.fish
      # Load the local fish config if it exists
      source ~/.local.fish
    end
end

