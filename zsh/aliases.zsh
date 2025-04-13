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
alias 'l'='exa'
alias 'll'='eza -l'
alias 'lh'='eza -al'
alias 'lv'='NVIM_APPNAME=nvim-lazy nvim'
alias 'ot'='tofu'
alias 'otf'="op run --env-file=.env -- terraform"
alias 'tg'='terragrunt'
alias 'tga'='terragrunt apply'
alias 'tgp'='terragrunt plan'
alias 'tgra'='terragrunt run-all apply'
alias 'tgrp'='terragrunt run-all plan'
alias 'vi'='${EDITOR}'
alias 'vim'='${EDITOR}'
alias '_'='sudo'

if  [ -f "$(which fdfind)" ]; then 
  FD=fdfind
elif [ -f "$(which fd)" ]; then
  FD=fd
fi

if eza &> /dev/null; then
  list_cmd="eza"
elif exa &> /dev/null ; then 
  list_cmd="eza"
else
  list_cmd="ls"
fi

alias 'l'='$list_cmd'
alias 'ls'='$list_cmd'
alias 'll'='$list_cmd -l'
alias 'la'='$list_cmd -al'

if [ -n "${FD}" ]; then
  alias 'c'='${FD} --type d --exclude .git | fzf-tmux -p --reverse | cd <'
  alias 'v'='${FD} --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim'
fi

