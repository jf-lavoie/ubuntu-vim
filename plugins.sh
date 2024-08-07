#!/bin/bash
#
# taken here: https://unix.stackexchange.com/questions/228331/avoid-running-the-script-if-a-variable-is-not-defined
set -u # or set -o nounset
echo INSTALL_VI_ROOTPATH "$INSTALL_VI_ROOTPATH"
echo INSTALL_VI_BUNDLEPATH "$INSTALL_VI_BUNDLEPATH"

mkdir -p $INSTALL_VI_BUNDLEPATH

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

	if [ -d "$HOME"/.fzf ]; then
		"$HOME"/.fzf/uninstall
	fi

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
	grep -qF 'export FZF_DEFAULT_COMMAND="rg' "$HOME"/.bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >>"$HOME"/.bashrc

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

	local LUAVERSION=5.1.5 # nvim = 5.1 source: https://neovim.io/doc/user/lua.html
	local LUAROCKSVERSION=3.9.2

	sudo apt update &&
		sudo apt upgrade &&
		sudo apt install build-essential libreadline-dev unzip

	mkdir -p "$HOME/lua"

	pushd "$HOME/lua" || exit

	if [ ! -f "lua-$LUAVERSION.tar.gz" ]; then
		curl -R -O -L https://www.lua.org/ftp/lua-$LUAVERSION.tar.gz
	fi
	rm -rf lua-$LUAVERSION
	tar -zxf "lua-$LUAVERSION.tar.gz"

	pushd lua-$LUAVERSION || exit

	make linux test
	make local

	ln -sfv "$PWD/bin/lua" "$HOME/bin/lua"
	ln -sfv "$PWD/bin/luac" "$HOME/bin/luac"

	popd || exit # lua-$LUAVERSION-sources

	if [ ! -f luarocks-$LUAROCKSVERSION.tar.gz ]; then
		wget https://luarocks.org/releases/luarocks-$LUAROCKSVERSION.tar.gz
	fi
	rm -rf luarocks-$LUAROCKSVERSION
	tar zxpf luarocks-$LUAROCKSVERSION.tar.gz

	pushd "luarocks-$LUAROCKSVERSION" || exit
	./configure --prefix="$HOME/lua/luarocks-$LUAROCKSVERSION/installation" --with-lua-include="$HOME/lua/lua-$LUAVERSION/include" && make && sudo make install
	make

	ln -sfv "$PWD/installation/bin/luarocks" "$HOME/bin/luarocks"
	ln -sfv "$PWD/installation/bin/luarocks-admin" "$HOME/bin/luarocks-admin"
	popd || exit # "luarocks-$LUAROCKSVERSION"

	popd || exit # luarocks

	# for windows, eventually: https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Windows

}

nvim-packer

# environment related
fzf
# fonts # for neotree
fonts
vim-minimap
lua
