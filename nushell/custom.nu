# ALiases
alias gfa = git fetch --all
alias gco = git checkout
alias gfm = git pull --no-rebase
alias k = kubectl
alias l = ls
alias la = ls -al
alias ll = ls -l
alias lg = lazygit
alias e = nvim
alias v = nvim
alias vim = nvim

# Custom functions
# Git fetch all and pull without rebase
def ggg [] {
  git pull --no-rebase
  git fetch --all
}

def ec [filename?: string] {
  if ($filename |is-empty) {
    nvim ~/.config/nushell/
  } else {
    nvim ( $env.XDG_CONFIG_HOME | path join nushell $filename)
  }
}

def gitlab_token [] {
  echo "GITLAB_TOKEN=$GITLAB_TOKEN"
}

# Nushell function to reload config by sourcing files
# def rc [] {
#   print "Reloading nushell config..."
#   source $nu.config-path
#   print "Done!"
# }

# List all files in a directory, defaults to current directory
def lf [dir?: string = "."] {
  ls -al ($dir) | where type == file
}
