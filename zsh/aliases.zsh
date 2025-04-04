if ! tenv list &> /dev/null; then
  alias 'tf'='terraform'
fi

alias 'cat'='bat'
alias 'e'='${EDITOR}'
alias 'fcz'='cd $(fd ~/code --type d --max-depth 20 | fzf)'
alias 'fz'='cd $(fd . --type d --max-depth 20 | fzf )'
alias 'g'='grep'
alias 'ga'='git add'
alias 'gd'='git diff'
alias 'gf'='git fetch --all -p'
alias 'gfm'='git fetch origin'
alias 'ggg'='gfm;gfa -p'
alias 'gls'='glab ci status'
alias 'grep'='rg'
alias 'gss'='git status --short'
alias 'k'='kubectl'
alias 'kgn'='kubectl get nodes'
alias 'lg'='lazygit'
alias 'll'='ls -l'
alias 'lh'='ls -al'
alias 'lv'='NVIM_APPNAME=nvim-lazy nvim'
alias 'ot'='tofu'
alias 'otf'="op run --env-file=.env -- terraform"
alias 'tg'='terragrunt'
alias 'tga'='terragrunt apply'
alias 'tgp'='terragrunt plan'
alias 'tgra'='terragrunt run-all apply'
alias 'tgrp'='terragrunt run-all plan'
alias 'v'='${EDITOR}'
alias 'vi'='${EDITOR}'
alias 'vim'='${EDITOR}'
alias '_'='sudo'

if  [ -f "$(which fdfind)" ]; then 
  FD=fdfind
elif [ -f "$(which fd)" ]; then
  FD=fd
fi

if [ -n "${FD}" ]; then
  alias 'c'='${FD} --type d --exclude .git | fzf-tmux -p --reverse | cd <'
  alias 'v'='${FD} --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim'
fi

