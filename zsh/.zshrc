### Added by Zinit's installer
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

zinit light-mode for zdharma-continuum/zinit-annex-bin-gem-node

# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma-continuum/history-search-multi-word

# Two regular plugins loaded without investigating.
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# Git plugin from Oh My Zsh - loaded when entering a git repository
zinit ice wait lucid
zinit snippet OMZP::git

# Cache evals
zinit light mroth/evalcache

zinit light b4b4r07/enhancd
zinit light Peltoche/lsd
zinit wait"1" lucid from"gh-r" as"null" for \
  sbin"**/bat"  @sharkdp/bat \
  sbin"**/exa"  ogham/exa

# direnv
zinit as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
  atpull'%atclone' pick"direnv" src"zhook.zsh" for \
  direnv/direnv

# Lazygit
zi for \
    from'gh-r' \
    sbin'**/lazygit' \
  jesseduffield/lazygit

export HISTFILE=~/.zsh_history
export TERM=xterm-256color

[[ -n $TMUX ]] && export TERM="xterm-256color"

# 1password completion
# [ -f "$(which op)" ] && eval $(op completion zsh)
#
zi for \
    from'gh-r'  \
    sbin'**/fx* -> fx' \
  @antonmedv/fx

zi for \
    from'gh-r' \
    sbin'**/delta -> delta' \
  dandavison/delta

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
source <(carapace _carapace)

zinit load atuinsh/atuin

# My own aliases and functions
MY_ALIASES=${ZDOTDIR:-$HOME}/aliases.zsh
[ -f $MY_ALIASES ] && source $MY_ALIASES

MY_FUNCTIONS=${ZDOTDIR:-$HOME}/functions.zsh
[ -f $MY_FUNCTIONS ] && source $MY_FUNCTIONS

# local config for things like AWS credentials
[ -f ~/.local.zsh ] && source ~/.local.zsh

zi for \
    from'gh-r' \
    sbin'**/starship -> starship' \
  starship/starship
