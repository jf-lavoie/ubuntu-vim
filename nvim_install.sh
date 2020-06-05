#!/bin/bash


installationRoot=$HOME/.config/nvim
rm -rf $installationRoot

if [ ! -d $installationRoot ]; then
  mkdir -p $installationRoot
fi

# bundlePath=$installationRoot/bundle
# nativeBundlePath=$HOME/.local/share/nvim/site/pack

bundlePath=$HOME/.local/share/nvim/site/pack/plugins/start

currentFolder=$PWD

sudo apt update

# installing pip3 and install/enable python2 and pip2
# taken here: https://linuxize.com/post/how-to-install-pip-on-ubuntu-20.04/
sudo apt install neovim
sudo add-apt-repository universe
sudo apt update 
sudo apt install python2
curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
sudo python2 get-pip.py
pip2 --version
rm get-pip.py

sudo apt install python3-pip
pip3 --version

# taken here: https://github.com/neovim/pynvim
pip2 install pynvim
pip3 install pynvim

./plugins.sh $installationRoot $bundlePath

# https://github.com/neovim/neovim/wiki/Installing-Neovim
# Do I really want that?
# sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
# sudo update-alternatives --config vi
# sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
# sudo update-alternatives --config vim
# sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
# sudo update-alternatives --config editor


function vimrc {
  local dest=$currentFolder

  pushd $installationRoot

  echo Symlinking init.vim
  rm init.vim
  ln -s $dest/init.vim init.vim

  popd
}

vimrc
