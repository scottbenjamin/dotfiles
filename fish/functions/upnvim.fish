
function upnvim
  echo "Updating neovim from source..."

  set NVIM_CODE_DIR $HOME/code/neovim

  if ! test -d $NVIM_CODE_DIR
    mkdir -p $HOME/code
    git clone https://github.com/neovim/neovim.git $NVIM_CODE_DIR
  end

  cd $NVIM_CODE_DIR && git pull && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local install

  cd -

  nvim --version
end
