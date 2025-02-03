alias 'vim'='nvim'
alias 'vi'='nvim'
alias 'v'='nvim'

alias 'cat'='bat'

alias 'tf'='terraform'
alias 'tg'='terragrunt'

alias 'k'='kubectl'

alias 'grep'='rg'
alias 'g'='grep'
alias 'lg'='lazygit'
alias 'fz'='cd $(fd . --type d --max-depth 20 | fzf )'
alias 'fcz'='cd $(fd ~/code --type d --max-depth 20 | fzf)'

alias 'otf'="op run --env-file=.env -- terraform"

# alias 'poetry'='pipx run poetry==1.3.2'

alias 'gls'='glab ci status'
alias 'ggg'='gfm;gfa -p'
alias 'ga'='git add'
alias 'gss'='git status --short'
alias 'gd'='git diff'

if  [ -f "$(which fdfind)" ]; then 
  FD=fdfind
elif [ -f "$(which fd)" ]; then
  FD=fd
fi

if [ -n "${FD}" ]; then
	alias 'c'='${FD} --type d --exclude .git | fzf-tmux -p --reverse | cd <'
	alias 'v'='${FD} --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim'
fi

alias 'vv'='NVIM_APPNAME=nvim-new nvim'
