# ALiases
#alias e = nvim
#alias ga  = git add 
#alias gco = git checkout
#alias gfa = git fetch --all
#alias gfm = git pull --no-rebase
#alias gs  = git status 
#alias k = kubectl
#alias kg = kubectl get
#alias l = ls
#alias la = ls -al
#alias lg = lazygit
#alias ll = ls -l
#alias v = nvim
#alias vim = nvim
#
#alias switch = darwin-rebuild switch --flake ~/code/dotfiles/nix-darwin/
#alias check = darwin-rebuild check --flake ~/code/dotfiles/nix-darwin/

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

# Update Nvim configs by setting XDG_CONFIG_HOME to dotfiles git repo
def uv [] {
  $env.XDG_CONFIG_HOME = ($nu.home-path | path join code dotfiles)
  print $"Updating nvim configs... using ($env.XDG_CONFIG_HOME)"
  nvim
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
