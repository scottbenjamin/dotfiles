# Environment variables
load-env {
  "AWS_PROFILE": "root"
  "MYVAULT" : "Couplify"
  "ACCOUNT" : "my.1password.com"
}

const kube_config_dir = ($nu.home-path | path join .kube)


def gitlab_api [] {
  op read op://($env.MYVAULT)/gitlab terraform api token/credential --account ($env.ACCOUNT)
}

# Test if AWS STS token is valid, if not auth with AWS
def check_aws_session [profile: string] {
    if (aws sts get-caller-identity --profile ($profile) --output text out+err>| str contains 'ExpiredToken') {
        print "AWS session expired, authenticating with aws..."
        gimme-aws-creds --profile=aws
    }
}


# test if OCI session is valid or 
def check_oci_session [profile: string, region: string] {

  if not ( oci session validate --profile $profile ) {
    if ( oci session refresh --profile $profile ) {
      return true
    } else {
      return false
    }
  } else {
    return true
  }
  
}

def oci_auth [profile: string, region: string] {
  let res = (check_oci_session $profile $region)
  if not $res {
    oci session authenticate --auth security_token --profile-name ($profile) --region ($region) 
  }
}
