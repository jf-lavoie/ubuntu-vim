#!/bin/bash

source .env.nvim
currentFolder="$PWD"

# rm -rf "$INSTALL_VI_ROOTPATH"

# if [ ! -d "$INSTALL_VI_ROOTPATH" ]; then
# 	mkdir -p "$INSTALL_VI_ROOTPATH"
# fi

# if [ -f "$INSTALL_NVIM_APPIMAGE_PATH"/nvim.appimage ]; then
# 	rm "$INSTALL_NVIM_APPIMAGE_PATH"/nvim.appimage
# fi

# curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
# chmod u+x nvim.appimage

# mv nvim.appimage "$INSTALL_NVIM_APPIMAGE_PATH"

# ln -vfs "$INSTALL_NVIM_APPIMAGE_PATH"/nvim.appimage "$INSTALL_NVIM_APPIMAGE_PATH"/nvim

function links {

	local dest="$currentFolder"

	pushd "$INSTALL_VI_ROOTPATH" || exit

	echo Symlinking init.vim
	ln -sf "$dest"/init.vim init.vim

	echo Symlinking init.lua
	ln -sf "$dest"/init.lua init.vim.lua

	# lua files
	mkdir -p lua/jf
	pushd lua/jf || exit
	# shellcheck disable=2045
	for f in $(ls "$dest"/lua/jf); do
		echo Symlinking lua/"$f"
		ln -sfv "$dest"/lua/jf/"$f" "$f"
	done
	popd || exit # lua/jf

  ln -sfv "$dest"/vim-jfsnippets vim-jfsnippets

	popd || exit # $INSTALL_VI_ROOTPATH
}

links


# python3 -m pip install --upgrade pynvim

# # taken from :checkhealth
# npm install -g neovim

# ./plugins.sh
