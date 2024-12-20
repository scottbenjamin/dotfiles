
# Environment variables
load-env {
  "AWS_PROFILE": "root"
  "MYVAULT" : "Employee"
  "ACCOUNT" : "absci"
}

const kube_config_dir = ($nu.home-path | path join .kube)

# Grab the 1password token from DevOps vault
def onetoken [] {
    op item get --vault DevOPS "DevOps Vault Access Token: terraform" --fields credential --reveal --account ($env.ACCOUNT)
}


def gitlab_api [] {
  op read op://($env.MYVAULT)/gitlab-sb-rw-api-repo/credential --account ($env.ACCOUNT)
}

def check_retcode [code: int] {

  if $code == 0 {
    return  true
  } else {
    return false
  }
}

## CLOUD AUTH

# Test if AWS STS token is valid, if not auth with AWS
def check_aws_session [profile: string] {
    if (aws sts get-caller-identity --profile ($profile) --output text out+err>| str contains 'ExpiredToken') {
        print "AWS session expired, authenticating with aws..."
        gimme-aws-creds --profile=aws
    }
}

# test if OCI session is valid or 
def check_oci_session [profile: string] {

  oci session validate --local --profile ($profile)
  mut res = check_retcode $env.LAST_EXIT_CODE
  
  if not ($res) {
    oci session refresh --profile $profile
    $res = check_retcode $env.LAST_EXIT_CODE
  }

  return $res
}

def oci_auth [profile: string, region: string] {
  check_oci_session $profile 

  let res = check_retcode $env.LAST_EXIT_CODE

  if $res {
    oci session authenticate --auth security_token --profile-name ($profile) --region ($region) 
  } 
}

# Access and use kubeconfig for EKS clusters
def eks_creds --env [cluster_name: string, account_name: string] {
    print $"Accessing EKS cluster [ ($cluster_name) ] credentials from AWS"
    check_aws_session $account_name
    let kubeconfig_path = ($kube_config_dir | path join kubeconfig_($account_name)_($cluster_name))
    aws eks update-kubeconfig --name usw2-($account_name)-($cluster_name) --region us-west-2 --profile ($account_name) --kubeconfig ($kubeconfig_path)
    $env.KUBECONFIG = $kubeconfig_path
    let current_context = (kubectl config current-context)
    let new_contxt = ($current_context | str replace -r ".*/" "")
    kubectl config rename-context ($current_context) ($new_contxt)
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

