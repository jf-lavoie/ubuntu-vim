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

ln -vfs $INSTALL_NVIM_APPIMAGE_PATH/nvim.appimage  $INSTALL_NVIM_APPIMAGE_PATH/nvim

function vimrc {

  local dest=$currentFolder

  pushd $INSTALL_VI_ROOTPATH

  echo Symlinking init.vim
  ln -s $dest/init.vim init.vim

  echo Symlinking init.lua
  ln -sf $dest/init.lua init.vim.lua

  echo Symlinking lua/plugins.lua
  mkdir -p ~/.config/nvim/lua
  ln -sfv ~/ubuntu-vim/lua/plugins.lua ~/.config/nvim/lua/plugins.lua

  popd
}

vimrc

python3 -m pip install --upgrade pynvim


# taken from :checkhealth
npm install -g neovim


# ./plugins.sh
