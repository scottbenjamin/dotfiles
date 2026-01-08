# Disable fish greeting
function fish_greeting; end

fish_add_path ~/.local/bin
fish_add_path ~/.npm-packages/bin
fish_add_path /opt/homebrew/bin
fish_add_path ~/.local/share/mise/shims

for p in /run/current-system/sw/bin ~/bin
    if not contains $p $fish_user_paths
        set -g fish_user_paths $p $fish_user_paths
    end
end

if status is-interactive
    set -xg EDITOR nvim
    set -xg VISUAL_EDITOR nvim

    if test -d "$HOMEBREW_PREFIX/share/fish/completions"
        set -p fish_complete_path $HOMEBREW_PREFIX/share/fish/completions
    end

    if test -d "$HOMEBREW_PREFIX/share/fish/vendor_completions.d"
        set -p fish_complete_path $HOMEBREW_PREFIX/share/fish/vendor_completions.d
    end

    if test -d "$HOMEBREW_PREFIX/opt/rustup/bin"
        fish_add_path $HOMEBREW_PREFIX/opt/rustup/bin
    end

    # Lazy load carapace
    if type -q carapace
        set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
        function __carapace_lazy --on-event fish_complete
            functions --erase __carapace_lazy
            carapace _carapace | source
        end
    end

    # Lazy load zoxide
    if type -q zoxide
        function z --wraps=zoxide
            functions --erase z zi
            zoxide init fish | source
            z $argv
        end
        function zi --wraps=zoxide
            functions --erase z zi
            zoxide init fish | source
            zi $argv
        end
    end

    # Lazy load atuin
    if type -q atuin
        function __atuin_lazy_init
            functions --erase __atuin_lazy_init
            atuin init fish | source
            commandline -f repaint
        end
        bind \cr __atuin_lazy_init
        bind up __atuin_lazy_init
    end

    # Lazy load direnv - init on first cd, then let direnv handle it
    if type -q direnv
        function __direnv_lazy --on-variable PWD
            # Check if any parent dir has .envrc
            set -l check_dir $PWD
            while test "$check_dir" != ""
                if test -f "$check_dir/.envrc"; or test -f "$check_dir/.env"
                    # Found envrc, init direnv permanently and remove this lazy loader
                    functions --erase __direnv_lazy
                    direnv hook fish | source
                    __direnv_export_eval
                    return
                end
                set check_dir (string replace -r '/[^/]*$' '' $check_dir)
            end
        end
    end

    # Using pure prompt (async git, fast)

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

    if test -d /opt/wine-cachyos
        set -gx PATH /opt/wine-cachyos/bin $PATH
        set -gx WINEDLLPATH /opt/wine-cachyos/lib/wine /opt/wine-cachyos/lib32/wine $WINEDLLPATH
        set -gx LD_LIBRARY_PATH /opt/wine-cachyos/lib /opt/wine-cachyos/lib32 $LD_LIBRARY_PATH
    end
end
