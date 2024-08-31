export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZIM_HOME="${XDG_CONFIG_HOME}/zim"
export HISTFILE=~/.zsh_history

# Customize to your needs...
export PATH=$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:/opt/homebrew/bin:$PATH

# My fav
export EDITOR=nvim
export VISUAL="${EDITOR}"
export SUDO_EDITOR="${EDITOR}"

# Tmux
export TERM=xterm-256color
git config --global core.editor ${EDITOR}


# Nvim 
# export NVIM_APPNAME=nvim-lazy
[ -d ~/.cargo/env ] && source "$HOME/.cargo/env"
