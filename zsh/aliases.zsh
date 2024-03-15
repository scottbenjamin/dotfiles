alias 'vim'='nvim'
alias 'vi'='nvim'
alias 'cat'='bat'
#alias 'glapi'='op read op://scott.benjamin/registry_token/credential --account mantium |  pbcopy'

alias 'tf'='terraform'
alias 'gltfinit'='tofu init -backend-config="username=sbenjamin55" -backend-config="password=$(_gitlab_api)"'

alias 'k'='kubectl'

alias 'grep'='rg'
alias 'g'='grep'
alias 'lg'='lazygit'
alias 'fz'='cd $(fd . --type d --max-depth 20 | fzf )'
alias 'fcz'='cd $(fd ~/code --type d --max-depth 20 | fzf)'

alias 'otf'="op run --env-file=.env -- terraform"

# alias 'poetry'='pipx run poetry==1.3.2'

alias 'gls'='glab ci status'
alias 'ggg'='gfm;gfa'

if [ -f $(which fd) ]; then
	alias 'c'='fd --type d --exclude .git | fzf-tmux -p --reverse | cd <'
	alias 'v'='fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim'
fi

alias 'vks'='NVIM_APPNAME=nvim-new nvim'
