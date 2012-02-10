#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
#
## restart running processes on exit
#setopt HUP

## Enable AutoCD
setopt autocd

## history
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

## never ever beep ever
setopt NO_BEEP

##
setopt prompt_subst
setopt AUTOCD INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB
setopt HIST_IGNORE_SPACE

## automatically decide when to page a list of completions
#LISTMAX=0

REPORTTIME=60       # Report time statistics for progs that take more than a minute to run
WATCH=notme         # Report any login/logout of other users
WATCHFMT='%n %a %l from %m at %T.'

## disable mail checking
MAILCHECK=0

autoload -U compinit
compinit

export PATH=$PATH:$HOME/bin:/usr/local/bin

# Variables used for dotfiles
host=$(hostname -s)

## P4
export P4CONFIG=.p4config
export P4USER=sbenjamin
export P4PORT=scm.nimone.com:1666
export P4CLIENT="sbenjamin_$host"

if [[ $(uname) == 'Darwin' ]]; then
	export P4PORT=localhost:1666
	export P4CLIENT="sbenjamin_mac"
fi

export REPLYTO=sbenjamin@networksinmotion.com

### Colors ---
#source ~/bin/colors.sh

## Oracle
if [ -d /usr/lib/oracle/11.2/client/ ]; then
    export ORACLE_HOME=/usr/lib/oracle/11.2/client/
elif [ -d /usr/lib/oracle/xe/app/oracle/product/10.2.0/client ]
then
    export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/client
elif [ -d /usr/local/nb/oracle/product/10.2.0.3/client_1/ ]
then
    export ORACLE_HOME=/usr/local/nb/oracle/product/10.2.0.3/client_1/
fi

export NLS_LANG='.AL32UTF8'
export PATH=$PATH:$ORACLE_HOME/bin

alias sqlplus='rlwrap $ORACLE_HOME/bin/sqlplus'

if [ -d ~/.oracle ]; then
    export ORACLE_PATH="~/.oracle:$ORACLE_PATH"
    export TNS_ADMIN="~/.oracle"
fi

#NB Related variables
export PYTHON_INCLUDE=/usr/include/python2.4
export LD_LIBRARY_PATH=/lib:/usr/lib:$ORACLE_HOME/lib

## History
export HISTFILE="$HOME/.history"
export SAVEHIST=10000
export HISTSIZE=10000
export HISTCONTROL=ignoreboth

## My trusty sidekick
export EDITOR=emacs

## Prompt
autoload -U colors zsh/terminfo
colors

## Allow completion of SSH host names
local _myhosts
if [[ -f $HOME/.ssh/known_hosts ]]; then
  _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
  zstyle ':completion:*' hosts $_myhosts
fi

hostname=$(hostname)

#export LS_COLORS="no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"

## Prompt ------
#export PS1="%{$fg[white]%}( %@ )\n%{$fg[green]%}%n%{$fg_bold[white]%}:%{$fg[blue]%} %1d %{$fg[white]%}>%{$reset_color%} "
#export PS1="%m %{${fg_bold[red]}%}:: %{${fg[green]}%}%3~%(0?. . ${fg[red]}%? )%{${fg[blue]}%}»%{${reset_color}%} "

#export PROMPT='[ %{$fg[white]%}%* %{$fg[green]%}%n@%M%{$fg[white]%} ]
#(%{$fg[blue]%}%B%20~%b%{$reset_color%}%}) $ '
#
PROMPT="[%{$fg[green]%}%n@%m %{$reset_color%} %{$fg_bold[grey]%}%{$reset_color%}%~ ]
%* %{$reset_color%}>> "

export PS2="--> "

function title() {
  # escape '%' chars in $1, make nonprintables visible
#  a=${(V)1//\%/\%\%}
  a=$host

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\e]2;$a @ $2\a" # plain xterm title
    print -Pn "\ek$a\e\\"      # screen title (in ^A")
    print -Pn "\e_$2   \e\\"   # screen location
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$a @ $2\a" # plain xterm title
    ;;
  esac
}

# precmd is called just before the prompt is printed
function precmd() {
  title "zsh" "%m(%55<...<%~)"
}

# preexec is called just before any command line is executed
function preexec() {
  title "$1" "%m(%35<...<%~)"
}

# Get rid of the BELL!!!
set bell-style visible

# set fast keyboard repeat rate
#xset r rate 250 70 > /dev/null 2>&1

# Key Bindings
bindkey -e

NB='/usr/local/nb'

# User specific aliases and functions
if [[ "$host" == "map1" ]]
then
    alias mdr='cd /data1/Map_Data/NIM_Map_Data_Released'
    alias crepo='createrepo --update /data3/yum/navbuilder/noarch/;chmod -R g+w /data3/yum/navbuilder/noarch/ >/dev/null 2>&1'
    umask 002
fi


## Aliases
source ~/.aliases

## Functions
source ~/.functions
