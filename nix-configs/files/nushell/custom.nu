# Load any commands/aliases unique to this host
const local_nu = ($nu.home-path | path join .local.nu)
if ($local_nu | path exists) {
    source ($local_nu)
}

# ---------------------------------------------------
# Aliases
# ---------------------------------------------------
alias g = rg;
alias ga = git add
alias gco = git checkout
alias gfa = git fetch --all
alias gfm = git pull --no-rebase
alias gs = git status
alias gss = git status --short
alias k = kubectl
alias kg = kubectl get
alias kgp = kubectl get pods
alias l = ls
alias la = ls -al
alias lg = lazygit
alias ll = ls -l
alias tg = terragrunt
alias v = vim
alias vim = vim
alias nsn = nix search nixpkgs

# ---------------------------------------------------
# Custom Commands
# ---------------------------------------------------
 
# Run darwin-rebuild switch
def drs [] {
  darwin-rebuild switch --flake $env.MY_NIX_CONFIGS
}

# Run darwin-rebuild check
def drc [] {
  darwin-rebuild check --flake $env.MY_NIX_CONFIGS
}



