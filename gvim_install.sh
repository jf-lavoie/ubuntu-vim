#!/bin/bash

source .env.gvim

rm -rf "$INSTALL_VI_ROOTPATH"

if [ ! -d "$INSTALL_VI_ROOTPATH" ]; then
  mkdir -p "$INSTALL_VI_ROOTPATH"
fi

currentFolder=$PWD

sudo apt update

# https://askubuntu.com/a/1234566/353419
sudo apt install vim-gtk3 

./plugins.sh

function vimrc {
  local dest=$currentFolder

  pushd "$HOME" || exit

  echo Symlinking .vimrc
  rm .vimrc
  ln -s "$dest"/init.vim .vimrc

  popd || exit
}

vimrc
