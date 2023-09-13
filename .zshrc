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
export PATH=$HOME/bin:$HOME/.cargo/bin:/opt/homebrew/bin:$PATH

# 1password completion
eval "$(op completion zsh)"; compdef _op op

FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"


autoload bashcompinit && bashcompinit
autoload -U compinit && compinit

# AWS CLI command completion
complete -C $(which aws_completer) aws

# AZ CLI command completion
source /opt/homebrew/etc/bash_completion.d/az

# Zellij completions
source /opt/homebrew/etc/bash_completion.d/zellij

# ENV Variables
export EDITOR=nvim

# My own aliases and functions
[ -f ~/.aliases.zsh ] && source ~/.aliases.zsh
[ -f ~/.functions.zsh ] && source ~/.functions.zsh

# iterm2 integration
#source ~/.iterm2_shell_integration.zsh

export TERM=xterm-256color
[[ -n $TMUX ]] && export TERM="xterm-256color"

# Starship prompt
eval "$(starship init zsh)"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Zellij
# eval "$(zellij setup --generate-auto-start zsh)"
