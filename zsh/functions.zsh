
ACCOUNT="my.1password.com"
MYVAULT="Couplify"

_cloudflare_api () {
  op read "op://$MYVAULT/Cloudflare TF API Token/credential" --account $ACCOUNT
}

_gitlab_api() {
  op read "op://$MYVAULT/gitlab terraform api token/credential" --account $ACCOUNT
}

_gitlab_ld() {
  op read "op://$MYVAULT/GitlabLocalDev/credential" --account $ACCOUNT
}

_pd_api() {
  op read 'op://scott.benjamin/5jvjmruz24zaq6loh2qpwto2sq/credential' --account $ACCOUNT
}

__wezterm_osc7() {
  if hash wezterm 2>/dev/null ; then
    wezterm set-working-directory 2>/dev/null && return 0
    # If the command failed (perhaps the installed wezterm
    # is too old?) then fall back to the simple version below.
  fi
  printf "\033]7;file://%s%s\033\\" "${HOSTNAME}" "${PWD}"
}

cvenv() {
  update=0
  #set -x  # to enable debugging
  usage() { echo "$0 -v PYTHON_VERSION -n VENV_NAME -u "}

  while getopts "h:v:n:u" arg; do
    case ${arg} in
      v)
        version=${OPTARG}
        ;;
      n)
        name=${OPTARG}
        ;;
      u)
        update=1
        ;;
      h|*)
        usage
        return
        ;;
    esac
  done

  if [ -n "$version" ]; then
    VERSION=$version
  else
    VERSION=3.10.8
  fi

  if [ -n "$name" ]; then
    NAME=$name
  else
    NAME=$(basename $PWD)
  fi

  if [[ $update -eq 1 ]]; then
    echo -e "\nInstalling/updating pyenv."
    brew install pyenv -q
  fi

  echo -e "\nInstalling Python ${VERSION} via pyenv (if needed) "
  pyenv install ${VERSION} -s

  echo -e "\nCreating Virualenv ${NAME}."
  pyenv virtualenv --upgrade-deps ${VERSION} ${NAME}

}


# Function to run darwin-rebuild with specified action
dr() {
  MY_NIX_CONFIGS=~/code/dotfiles/nix-configs
  local action=$1
  local action_full

  case $action in
    "s")
      action_full="switch"
      ;;
    "b")
      action_full="build"
      ;;
    "c")
      action_full="check"
      ;;
    *)
      echo "Invalid action"
      return 1
      ;;
  esac

  darwin-rebuild $action_full --flake $MY_NIX_CONFIGS
}

