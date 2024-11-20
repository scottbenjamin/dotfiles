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
 
# Run darwin-rebuild with specified action
def dr [action: string] {
  let action_full = match $action {
    "s" => "switch",
    "b" => "build",
    "c" => "check",
    _ => { error "Invalid action" }
  }
  darwin-rebuild $action_full --flake $env.MY_NIX_CONFIGS
}

def check-connection-gitlab [] {
  let connection = (nc -zvw2 gitlab.absci.cloud 22 out>/dev/null)
  if $env.LAST_EXIT_CODE != 0 {
    return false
  } else {
    return true
  }
}


def pythonify [] {

  if (not ($env.PWD | path join .git | path exists)) {
    print "Not a git repository"
    return
  } 


}

def ggg [] {

  if (not ($env.PWD | path join .git | path exists)) {
    print "Not a git repository"
    return
  } 

    let default_branch = (git remote show origin | find HEAD | split row ":" |last | str trim |ansi strip)
    print "Fetching and pruning"
    git fetch --all -p

    print "Pulling origin ($default_branch)"
    git pull origin ($default_branch)
  }

# Enable updating lazyvim dotfiles since nix makes home-manager configs read-only
def uv [] {
  $env.XDG_CONFIG_HOME = ($nu.home-path | path join code dotfiles )
  print "Updating nvim dotfiles"
  nvim
}


# Environment variables
load-env {
  "AWS_PROFILE": "root"
  "MYVAULT" : "Employee"
  "ACCOUNT" : "absci"
}

const kube_config_dir = ($nu.home-path | path join .kube)

# Grab the 1password token from DevOps vault
def onetoken [] {
    op item get --vault DevOPS "DevOps Vault Access Token: terraform" --fields credential --reveal
}


def gitlab_api [] {
  op read op://($env.MYVAULT)/gitlab-sb-rw-api-repo/credential --account ($env.ACCOUNT)
}

# Test if AWS STS token is valid, if not auth with AWS
def check_aws_session [profile: string] {
    if (aws sts get-caller-identity --profile ($profile) --output text out+err>| str contains 'ExpiredToken') {
        print "AWS session expired, authenticating with aws..."
        gimme-aws-creds --profile=aws
    }
}

# Access and use kubeconfig for EKS clusters
def eks_creds --env [cluster_name: string, account_name: string] {
    print $"Accessing EKS cluster [ ($cluster_name) ] credentials from AWS"
    check_aws_session $account_name

    let kubeconfig_path = ($kube_config_dir | path join kubeconfig_($account_name)_($cluster_name))

    if (not ( $kubeconfig_path | path exists)) {
      aws eks update-kubeconfig --name usw2-($account_name)-($cluster_name) --region us-west-2 --profile ($account_name) --kubeconfig ($kubeconfig_path)
      $env.KUBECONFIG = $kubeconfig_path
      let current_context = (kubectl config current-context)
      let new_contxt = ($current_context | str replace -r ".*/" "")
      kubectl config rename-context ($current_context) ($new_contxt)
    } else {
      $env.KUBECONFIG = $kubeconfig_path
    }
}

# Function to access AI cluster credentials
def ai_cluster_creds --env [cluster_name: string] {
    # Access 1password credentials for the AI cluster
    let kubeconfig_path = ($kube_config_dir | path join admin-($cluster_name))

    if ( not ($kubeconfig_path | path exists)) {
      op read op://DevOps/kubeconfig_admin_($cluster_name)/admin-($cluster_name) --account $env.ACCOUNT | str replace --all  "kubernetes-admin@kubernetes" $"($cluster_name)" | save -f ($kubeconfig_path)
      chmod 600 $kubeconfig_path
    }

    $env.KUBECONFIG = $kubeconfig_path
}

# Main function to switch kubeconfig context
def kc --env [cluster_name: string, aws_account_name?: string] {
    if ($cluster_name | str length) == 0 {
        echo "Usage: kc <cluster_name> <optional aws_account_name>"
        return
    }

    match $cluster_name {
        "blue" | "green" | "h100" => { ai_cluster_creds $cluster_name }
        _ => {
              if ($cluster_name | str starts-with "eks") {
                  if ($aws_account_name | str length) == 0  {
                      echo "Usage: kc <cluster_name> <aws_account_name>"
                      return
                  } else {
                    eks_creds $cluster_name $aws_account_name
                  }
              } else {
                  $env.KUBECONFIG = ($nu.home-path | path join .kube ($cluster_name))
                  if not ($env.KUBECONFIG | path exists) {
                      echo "Kubeconfig file not found"
                      return
                  }
              }
        }
    }

    echo $"Kubeconfig set to ($env.KUBECONFIG)"
}

