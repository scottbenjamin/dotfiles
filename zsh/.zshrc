
# zmodload zsh/zprof

# Zimfw

zstyle ':zim:zmodule' use 'degit'
zstyle '
:zim' disable-version-check yes
ZIM_HOME=${ZIM_HOME:-$HOME/.config/zim}

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# End initialization of ZIM


export HISTFILE=~/.zsh_history
export TERM=xterm-256color

[[ -n $TMUX ]] && export TERM="xterm-256color"

# 1password completion
# _evalcache op completion zsh

setopt autocd

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

_evalcache atuin init zsh
_evalcache carapace _carapace
_evalcache zoxide init zsh
_evalcache starship init zsh

source ${ZDOTDIR}/aliases.sh
source ${ZDOTDIR}/functions.sh

[ -e ~/.local.zsh ] && source ~/.local.zsh

# zprof
