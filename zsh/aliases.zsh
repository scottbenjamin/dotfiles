alias 'vim'='nvim'
alias 'vi'='nvim'
alias 'v'='nvim'
alias 'lv'='NVIM_APPNAME=nvim-lazy nvim'

alias 'cat'='bat'

if ! tenv list &> /dev/null; then
  alias 'tf'='terraform'
fi

alias 'tg'='terragrunt'
alias 'tga'='terragrunt apply'
alias 'tgp'='terragrunt plan'
alias 'tgra'='terragrunt run-all apply'
alias 'tgrp'='terragrunt run-all plan'
alias 'ot'='tofu'

alias 'k'='kubectl'
alias 'kgn'='kubectl get nodes'

alias 'grep'='rg'
alias 'g'='grep'
alias 'lg'='lazygit'
alias 'fz'='cd $(fd . --type d --max-depth 20 | fzf )'
alias 'fcz'='cd $(fd ~/code --type d --max-depth 20 | fzf)'

alias 'otf'="op run --env-file=.env -- terraform"

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

alias e='${EDITOR}'
