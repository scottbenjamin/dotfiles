#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export PATH=$HOME/.local/share/bob/nvim-bin:$HOME/bin:$HOME/.cargo/bin:/opt/homebrew/bin:$PATH

# 1password completion
eval "$(op completion zsh)"; compdef _op op

FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

autoload bashcompinit && bashcompinit
autoload -U compinit && compinit

# AWS CLI command completion
complete -C $(which aws_completer) aws

# AZ CLI command completion
# AZ_COMPLETION=/opt/homebrew/etc/bash_completion.d/az
# [ -f $AZ_COMPLETION ] && source $AZ_COMPLETION

# Zellij completions
ZELLIJ_COMPLETION=/opt/homebrew/etc/bash_completion.d/zellij
[ -f $ZELLIJ_COMPLETION ] && source /opt/homebrew/etc/bash_completion.d/zellij

# ENV Variables
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=${EDITOR}

# My own aliases and functions
MY_ALIASES=$HOME/.aliases.zsh
[ -f $MY_ALIASES ] && source $MY_ALIASES

MY_FUNCTIONS=$HOME/.functions.zsh
[ -f $MY_FUNCTIONS ] && source $MY_FUNCTIONS

export TERM=xterm-256color
[[ -n $TMUX ]] && export TERM="xterm-256color"

# Starship prompt
[ -f $(which starship) ] && eval "$(starship init zsh)"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pyenv
if [ -f $(which pyenv) ]; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  eval "$(nodenv init -)"
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

# https://github.com/ajeetdsouza/zoxide
[ -f $(which zoxide) ] && eval "$(zoxide init zsh)"
