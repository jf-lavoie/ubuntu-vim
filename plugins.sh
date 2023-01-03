#!/bin/bash
#
# taken here: https://unix.stackexchange.com/questions/228331/avoid-running-the-script-if-a-variable-is-not-defined
set -u # or set -o nounset
echo INSTALL_VI_ROOTPATH "$INSTALL_VI_ROOTPATH"
echo INSTALL_VI_BUNDLEPATH "$INSTALL_VI_BUNDLEPATH"
echo INSTALL_VI_TARGET "$INSTALL_VI_TARGET"

currentFolder=$PWD
echo currentFolder "$currentFolder"

clone() {

	# "$1" repo path to clone
	# "$2" friendly name of the repo
	# "$3" -optionnal- the destination directory. uses the git clone default behavior if not provided

	# shellcheck disable=2155
	local defaultDest="$(basename "$1" .git)"
	# echo default "$defaultDest"

	# substiture 3rd parameter if not provided
	local dest=${3:-$defaultDest}
	# echo dest "$dest"
	#
	# shellcheck disable=2086
	echo Cloning $2 to "$INSTALL_VI_BUNDLEPATH/$dest"

	pushd "$INSTALL_VI_BUNDLEPATH" || exit

	if [ -d "$dest" ]; then
		rm -rf "$dest"
	fi

	mkdir -p "$dest"

	# shellcheck disable=2086
	git clone https://github.com/$1 "$dest"

	popd || exit # $INSTALL_VI_BUNDLEPATH

}

runCommand() {
	echo "Running command $1"
	bash -c "$INSTALL_VI_TARGET -U NONE --cmd \"$1\" --cmd \"qa\""
}

vim-minimap() {
	echo "vim-minimap"

	# MINIMAPDEBFILE=code-minimap-musl_0.5.0_amd64.deb
	local MINIMAPVERSION="0.6.4"
	# shellcheck disable=2027
	local MINIMAPDEBFILE="code-minimap_"$MINIMAPVERSION"_amd64.deb"
	# dependencies
	curl -LO "https://github.com/wfxr/code-minimap/releases/download/v$MINIMAPVERSION/$MINIMAPDEBFILE"
	sudo dpkg -r code-minimap
	sudo dpkg -i "$MINIMAPDEBFILE"
	rm "$MINIMAPDEBFILE"

	# clone wfxr/minimap.vim minimap.vim
}

fzf() {
	echo "cloning fzf"

	rm -rf "$HOME"/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf

	"$HOME"/.fzf/install --key-bindings --completion --update-rc

	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
	sudo dpkg -r ripgrep
	sudo dpkg -i ripgrep_13.0.0_amd64.deb
	rm ripgrep_13.0.0_amd64.deb

	# grep -qxF 'export FZF_DEFAULT_OPTS="--extended"' "$HOME"/.bashrc || echo 'export FZF_DEFAULT_OPTS="--extended"' >> "$HOME"/.bashrc
	# for the quoting escape black magic fuckery : https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
	# grep -qxF 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' "$HOME"/.bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >> "$HOME"/.bashrc

	# for the quoting escape black magic fuckery : https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
	grep -qF 'export FZF_DEFAULT_OPTS' "$HOME"/.bashrc || echo 'export FZF_DEFAULT_OPTS="--extended --preview '"'"'cat {}'"'"'"' >>"$HOME"/.bashrc
	grep -qF 'export FZF_DEFAULT_COMMAND="rg' "HOME/."bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >>"HOME/."bashrc

	source "$HOME"/.bashrc
}

nvim-packer() {
	echo installing wbthomason/packer.nvim

	clone wbthomason/packer.nvim.git wbthomason/packer.nvim

}

fonts() {
	echo installing fonts

	git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
	pushd nerd-fonts || exit

	./install.sh

	popd || exit
}

lua() {

	local LUAVERSION=5.1.5
	mkdir -p $HOME/lua
	pushd $HOME/lua

	curl -R -O http://www.lua.org/ftp/lua-$LUAVERSION.tar.gz
	tar -zxf lua-5.3.5.tar.gz
	cd lua-5.3.5
	make linux test
	sudo make install

	sudo apt update &&
		sudo apt upgrade &&
		apt install build-essential libreadline-dev unzip

	pushd $HOME/bin
	wget https://luarocks.org/releases/luarocks-3.9.1.tar.gz
	tar zxpf luarocks-3.9.1.tar.gz
	cd luarocks-3.9.1
	./configure --prefix=$HOME/lua/luarocks-3.9,1 && make && sudo make install

	popd

	# for windows, eventually: https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Windows

}

nvim-packer

# environment related
fzf
fonts # for neotree
vim-minimap
luarocks
