alias 'vim'='nvim'
alias 'vi'='nvim'
alias 'cat'='bat'
alias 'vpnpw'='op read op://scott.benjamin/vpn.mantiumai.com/password --account mantium |  pbcopy'
alias 'regpw'='op read op://scott.benjamin/registry_token/credential --account mantium |  pbcopy'
alias 'glapi'='op read op://scott.benjamin/registry_token/credential --account mantium |  pbcopy'
alias 'spotapi'='op read op://scott.benjamin/kd2hajenvsvrjslrgo3tnymdgi/credential --account mantium |  pbcopy'

alias 'tf'='terraform'
alias 'grep'='rg'
alias 'gltfinit'='terraform init -backend-config="username=$USER" -backend-config="password=$(_gitlab_api)" --reconfigure'

alias 'k'='kubectl'
alias 'kd'='KUBECONFIG=~/.kube/sandbox kubectl'
alias 'kg'='KUBECONFIG=~/.kube/gitlab-runners kubectl'
alias 'ks'='KUBECONFIG=~/.kube/staging kubectl'
alias 'kp'='KUBECONFIG=~/.kube/prod kubectl'
alias 'ksd'='KUBECONFIG=~/.kube/sandbox-dugong kubectl'
alias 'kas'='KUBECONFIG=~/.kube/sandbox_azure.kubeconfig kubectl'
alias 'kap'='KUBECONFIG=~/.kube/production_azure.kubeconfig kubectl'

alias 'g'='grep'
alias 'lg'='lazygit'
alias 'fz'='cd $(fd . --type d --max-depth 20 | fzf )'
alias 'fcz'='cd $(fd ~/code --type d --max-depth 20 | fzf)'

alias 'otf'="op run --env-file=.env -- terraform"

alias 'poetry'='pipx run poetry==1.3.2'

alias 'gls'='glab ci status'
alias 'ggg'='gfm;gfa'
