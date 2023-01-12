#!/bin/bash

source .env.nvim
currentFolder="$PWD"

rm -rf "$INSTALL_VI_ROOTPATH"

if [ ! -d "$INSTALL_VI_ROOTPATH" ]; then
	mkdir -p "$INSTALL_VI_ROOTPATH"
fi

if [ -f "$INSTALL_NVIM_APPIMAGE_PATH"/nvim.appimage ]; then
	rm "$INSTALL_NVIM_APPIMAGE_PATH"/nvim.appimage
fi

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

echo $INSTALL_NVIM_APPIMAGE_PATH
mv nvim.appimage "$INSTALL_NVIM_APPIMAGE_PATH"/nvim.appimage
chmod 755 "$INSTALL_NVIM_APPIMAGE_PATH"/nvim.appimage

sudo ln -sfv "$INSTALL_NVIM_APPIMAGE_PATH"/nvim.appimage /usr/bin/nvim

# function links {

# 	local dest="$currentFolder"

# 	pushd "$INSTALL_VI_ROOTPATH" || exit

# 	# echo Symlinking init.vim
# 	# ln -sf "$dest"/init.vim init.vim

# 	echo Symlinking init.lua
# 	ln -sf "$dest"/init.lua init.lua

# 	echo Symlinking custom snippets
# 	if [ ! -L vim-jfsnippets ]; then
# 		echo link did not exists
# 		ln -sfv "$dest"/vim-jfsnippets vim-jfsnippets
# 	fi

# 	# lua files
# 	mkdir -p lua/jf
# 	pushd lua/jf || exit
# 	# shellcheck disable=2045
# 	for f in $(ls "$dest"/lua/jf); do
# 		echo Symlinking lua/"$f"
# 		ln -sfv "$dest"/lua/jf/"$f" "$f"
# 	done
# 	popd || exit # lua/jf

# 	popd || exit # $INSTALL_VI_ROOTPATH
# }

# links

python3 -m pip install --upgrade virtualenv
sudo apt install python3-venv # required by Mason when installing debugpy

mkdir -p "$HOME/.virtualenvs"
pushd "$HOME"/.virtualenvs || exit
rm -rf pynvim
python3 -m venv pynvim
./pynvim/bin/python3 -m pip install --upgrade pynvim

rm-rf debugpy
python3 -m venv debugpy
debugpy/bin/python -m pip install debugpy

popd || exit # $HOME/.virtualenvs

# taken from :checkhealth
npm install -g neovim

./plugins.sh
