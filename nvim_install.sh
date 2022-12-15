#!/bin/bash

source .env.nvim

rm -rf $INSTALL_VI_ROOTPATH

if [ ! -d $INSTALL_VI_ROOTPATH ]; then
  mkdir -p $INSTALL_VI_ROOTPATH
fi

currentFolder=$PWD


if [ -f $INSTALL_NVIM_APPIMAGE_PATH/nvim.appimage ]; then
  rm $INSTALL_NVIM_APPIMAGE_PATH/nvim.appimage
fi

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

mv nvim.appimage $INSTALL_NVIM_APPIMAGE_PATH

echo "aliasing nvim to nvim.appimage in ~/.bash_aliases"
grep -qxF 'alias nvim=''nvim.appimage''' $HOME/.bash_aliases || echo 'alias nvim=''nvim.appimage''' >> $HOME/.bash_aliases

function vimrc {

  local dest=$currentFolder

  pushd $INSTALL_VI_ROOTPATH

  echo Symlinking init.vim
  rm -f init.vim
  ln -s $dest/init.vim init.vim

  popd
}

vimrc

python3 -m pip install --upgrade pynvim


# taken from :checkhealth
npm install -g neovim


./plugins.sh

echo "Source your bash rc to enable 'nvim'"




