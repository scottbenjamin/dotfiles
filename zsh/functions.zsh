ACCOUNT="my.1password.com"

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

# __wezterm_osc7() {
#   if hash wezterm 2>/dev/null ; then
#     wezterm set-working-directory 2>/dev/null && return 0
#     # If the command failed (perhaps the installed wezterm
#     # is too old?) then fall back to the simple version below.
#   fi
#   printf "\033]7;file://%s%s\033\\" "${HOSTNAME}" "${PWD}"
# }


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

function upnvim() {
  NVIM_CODE_DIR=$HOME/code/neovim
  if [ ! -d $NVIM_CODE_DIR ] ; then 
    mkdir -p $HOME/code 
    git clone https://github.com/neovim/neovim.git $NVIM_CODE_DIR
  fi
  cd $NVIM_CODE_DIR && git pull && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local install
  cd -
  nvim --version
}

function upnvim-tar()
{
  curl -OL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz | tar zxf - --strip-components=1 -C $HOME/.local
  nvim --version
}

function timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do
    /usr/bin/time $shell -i -c exit
  done
}

