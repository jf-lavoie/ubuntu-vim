#!/bin/bash

installationRoot=$HOME/.vim
rm -rf $installationRoot

if [ ! -d $installationRoot ]; then
  mkdir -p $installationRoot
fi

bundlePath=$installationRoot/pack/plugins/start


currentFolder=$PWD

sudo apt update

sudo apt install vim-gtk3 

./plugins.sh $installationRoot $bundlePath


function vimrc {
  local dest=$currentFolder

  pushd $HOME

  echo Symlinking .vimrc
  rm .vimrc
  ln -s $dest/init.vim .vimrc

  popd
}

vimrc
