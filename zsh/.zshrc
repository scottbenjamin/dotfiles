
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

autoload -Uz compinit
compinit

zinit ice depth=1 wait"1" lucid
# Plugin history-search-multi-word loaded with investigating.
zinit light zdharma-continuum/history-search-multi-word

# Two regular plugins loaded without investigating.
zinit ice depth=1 wait"1" lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice depth=1 wait"1" lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# Git plugin from Oh My Zsh - loaded when entering a git repository
zinit ice wait"2" lucid
zinit snippet OMZP::git

# Cache evals
zinit ice depth=1
zinit light mroth/evalcache

# direnv
zinit as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
  atpull'%atclone' pick"direnv" src"zhook.zsh" for \
  direnv/direnv

export HISTFILE=~/.zsh_history
export TERM=xterm-256color

[[ -n $TMUX ]] && export TERM="xterm-256color"

# 1password completion
[ -f "$(which op)" ] && _evalcache op completion zsh
#
set -o emacs

# pyenv
zinit ice wait lucid depth'1' \
    atclone'PYENV_ROOT="${HOME}/.pyenv" ./libexec/pyenv init - > zpyenv.zsh' \
    atinit'export PYENV_ROOT="${HOME}/.pyenv"' atpull"%atclone" \
    as'command' pick'bin/pyenv' src"zpyenv.zsh" compile'{zpyenv,completions/*}.zsh' nocompile'!' \
    atload'
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    # make zsh completion works no need source in zshrc. #1644
    # https://github.com/pyenv/pyenv/pull/1644
    _pyenv_new() {
        local -a comples
        if [ "${#words}" -eq 2 ]; then
            comples=($(pyenv commands))
        else
            comples=($(pyenv completions ${words[2,-2]}))
        fi
        _describe -t comples 'comples' comples
    }
    compdef _pyenv_new pyenv' \
    id-as'pyenv'
zinit light pyenv/pyenv

zinit ice wait lucid depth'1' \
    atclone'PYENV_ROOT="${HOME}/.pyenv" ./bin/pyenv-virtualenv-init - > zpyenv-virtualenv.zsh' \
    atinit'export PYENV_ROOT="${HOME}/.pyenv"' atpull"%atclone" \
    as'command' pick'bin/*' src"zpyenv-virtualenv.zsh" compile'*.zsh' nocompile'!' \
    atload'
    eval "$(pyenv init -)"' \
    id-as'pyenv-virtualenv'
zinit light pyenv/pyenv-virtualenv

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
_evalcache carapace _carapace

zinit ice depth"1" multisrc="${ZDOTDIR:-$HOME}/{functions,aliases}.zsh ~/.local.zsh"
zinit load atuinsh/atuin

_evalcache zoxide init zsh

_evalcache starship init zsh

