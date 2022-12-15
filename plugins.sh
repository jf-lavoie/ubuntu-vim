#!/bin/bash
#
# taken here: https://unix.stackexchange.com/questions/228331/avoid-running-the-script-if-a-variable-is-not-defined
set -u # or set -o nounset
echo INSTALL_VI_ROOTPATH $INSTALL_VI_ROOTPATH
echo INSTALL_VI_BUNDLEPATH $INSTALL_VI_BUNDLEPATH
echo INSTALL_VI_TARGET $INSTALL_VI_TARGET

currentFolder=$PWD
echo currentFolder $currentFolder

clone() {

  # $1 repo path to clone
  # $2 friendly name of the repo
  # $3 -optionnal- the destination directory. uses the git clone default behavior if not provided

  local defaultDest=$(basename $1 .git)
  # echo default $defaultDest

  # substiture 3rd parameter if not provided
  local dest=${3:-$defaultDest}
  # echo dest $dest
  echo Cloning $2 to $INSTALL_VI_BUNDLEPATH/$dest

  pushd $INSTALL_VI_BUNDLEPATH

  if [ -d $dest ]; then
    rm -rf $dest
  fi

  mkdir -p $dest

  git clone https://github.com/$1 $dest

  popd # $INSTALL_VI_BUNDLEPATH

}

runCommand() {
  echo "Running command $1"
  bash -c "$INSTALL_VI_TARGET -U NONE --cmd \"$1\" --cmd \"qa\""
}

vim-minimap() {
  echo "vim-minimap"

  MINIMAPDEBFILE=code-minimap-musl_0.5.0_amd64.deb
  # dependencies
  curl -LO https://github.com/wfxr/code-minimap/releases/download/v0.5.0/$MINIMAPDEBFILE
  sudo dpkg -r code-minimap-musl
  sudo dpkg -i $MINIMAPDEBFILE
  rm $MINIMAPDEBFILE

  clone wfxr/minimap.vim minimap.vim
}

fzf() {
  echo "cloning fzf"

  rm -rf $HOME/.fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf

  $HOME/.fzf/install --key-bindings --completion --update-rc

  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
  sudo dpkg -r ripgrep
  sudo dpkg -i ripgrep_12.1.1_amd64.deb
  rm ripgrep_12.1.1_amd64.deb

  # grep -qxF 'export FZF_DEFAULT_OPTS="--extended"' $HOME/.bashrc || echo 'export FZF_DEFAULT_OPTS="--extended"' >> $HOME/.bashrc
  # for the quoting escape black magic fuckery : https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
  # grep -qxF 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' $HOME/.bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >> $HOME/.bashrc

  # for the quoting escape black magic fuckery : https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
  grep -qF 'export FZF_DEFAULT_OPTS' $HOME/.bashrc || echo 'export FZF_DEFAULT_OPTS="--extended --preview '"'"'cat {}'"'"'"' >> $HOME/.bashrc
  grep -qF 'export FZF_DEFAULT_COMMAND="rg' $HOME/.bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >> $HOME/.bashrc

  source $HOME/.bashrc

  clone junegunn/fzf.vim fzf.vim
}

ultisnips() {
  echo installing 'ultisnips'
  clone SirVer/ultisnips.git ultisnips

  # also adding custom snippets
  # in order to work, the array g:UltiSnipsSnippetDirectories must contain "jf-snippets". Done in .vimrc
  pushd $INSTALL_VI_BUNDLEPATH
  rm -f vim-jfsnippets
  ln -s $currentFolder/vim-jfsnippets vim-jfsnippets
  popd
}

snippets() {
  echo installing 'snippets'
  clone honza/vim-snippets.git vim-snippets
}

commentary() {
  echo installing 'commentary'
  clone tpope/vim-commentary.git vim-commentary
}

neoformat() {
  echo installing 'neoformat'
  echo installer npm prettier globally first
  npm -g install prettier

  # local dest=$currentFolder
  # pushd $HOME
  # ln -s $dest/.prettierrc .prettierrc
  # popd

  clone sbdchd/neoformat.git neoformat
}

jsDoc() {
  echo installing 'jsDoc'
  clone heavenshell/vim-jsdoc.git vim-jsdoc
}

json() {
  echo installing 'json'
  clone elzr/vim-json.git vim-json
}

easyAlign() {
  echo installing 'easyAlign'
  clone junegunn/vim-easy-align.git vim-easy-align
}

fugitive() {
  echo installing 'vim-fugitive'
  clone tpope/vim-fugitive.git vim-fugitive
  runCommand "helptags $INSTALL_VI_BUNDLEPATH/vim-fugitive/doc" 
}

solarized() {
  # command to put in vimrc if I want to switch to solarized
  #
  # set background=dark
  # " I want high contrast diffs
  # let g:solarized_diffmode="high"
  # colorscheme solarized

  echo installing 'solarized' color scheme
  clone altercation/vim-colors-solarized.git vim-colors-solarized
}

monokai-tasty() {
  echo installing 'monokai-tasty' color scheme
  clone patstockwell/vim-monokai-tasty.git vim-monokai-tasty.vim
}

vim-monokai() {
  echo installing 'vim-monokai' color scheme
  clone crusoexia/vim-monokai.git vim-monokai
}

dracula() {
  echo installing 'dracula' color scheme
  clone dracula/vim.git dracula dracula
}

delimitMate() {
  echo insalling delimitMate
  clone Raimondi/delimitMate.git delimitMate

  runCommand "helptags  $INSTALL_VI_BUNDLEPATH/delimitMate/doc"
}

multipleCursors() {
  echo installing vim-multiple-cursors
  clone terryma/vim-multiple-cursors.git vim-multiple-cursors
}

lightline() {
  echo installing lightline
  clone itchyny/lightline.vim.git lightline.vim
}

vim-javascript() {
  echo installing vim-javasript
  clone pangloss/vim-javascript.git vim-javascript
}

vim-jsx-pretty() {
  echo installing vim-jsx-pretty
  clone MaxMEllon/vim-jsx-pretty.git vim-jsx-pretty
}


vim-go() {
  echo installing vim-go
  clone fatih/vim-go.git vim-go

  runCommand "GoInstallBinaries"
}
gitgutter() {
  echo installing git-gutter
  clone airblade/vim-gitgutter.git vim-gitgutter
  runCommand "helptags $INSTALL_VI_BUNDLEPATH/vim-gitgutter/doc" 
}

ale() {
  echo installing ale
  echo first, installing eslint
  npm -g install eslint
  # npm -g install eslint-plugin-prettier
  # npm -g install eslint-config-prettier


  # local dest=$currentFolder
  # pushd $HOME
  # ln -s $dest/.eslintrc .eslintrc
  # popd

  echo clonig ale

  clone dense-analysis/ale.git ale

  # mkdir -p $INSTALL_VI_BUNDLEPATH/ale/start
  # pushd $INSTALL_VI_BUNDLEPATH/ale/start
  # git clone https://github.com/w0rp/ale.git
  # popd
}

vim-closetag() {
  echo installing vim-closetag
  clone alvan/vim-closetag.git vim-closetag
}

vim-terraform() {
  echo installing vim-terraform
  clone hashivim/vim-terraform.git vim-terraform
}

vim-markdown() {
  echo installing vim-markdown
  clone plasticboy/vim-markdown.git plasticboy/vim-markdown
}

markdown-preview() {

  echo installing markdown-preview.nvim
  clone iamcco/markdown-preview.nvim.git iamcco/markdown-preview.nvim

  runCommand "call mkdp#util#install_sync()"
}

vim-subversive() {
  echo installing vim-subversive

  clone svermeulen/vim-subversive.git svermeulen/vim-subversive
}


vim-indentline() {

  echo installing vim-indentline

  clone Yggdroot/indentLine.git Yggdroot/indentLine

  runCommand "helptags  $INSTALL_VI_BUNDLEPATH/indentLine/doc"
}

vim-highlightedyank() {
  echo installing vim-highlightedyank.git

  clone machakann/vim-highlightedyank.git machakann/vim-highlightedyank
}

nvim-packer() {
  echo installing wbthomason/packer.nvim

  clone wbthomason/packer.nvim.git wbthomason/packer.nvim

}

pyright() {
  echo installing pyright, python language server

  npm i -g pyright@latest
}

sumneko_lua() {
  echo installing sumneko_lua, lua language server

  # required by the language server
  sudo apt update
  sudo apt-get install -y ninja-build

  clone sumneko/lua-language-server.git sumneko/lua-language-server


  pushd $INSTALL_VI_BUNDLEPATH/lua-language-server

  git submodule update --depth 1 --init --recursive

  cd 3rd/luamake
  echo +++++++++++++++++ Building lua language server +++++++++++++++++
  ./compile/install.sh
  cd ../..
  echo +++++++++++++++++ Re-Building lua language server +++++++++++++++++
  ./3rd/luamake/luamake rebuild

  ln -sfv $(pwd)/bin/lua-language-server $HOME/bin/lua-language-server

  popd #$INSTALL_VI_BUNDLEPATH\lua-language-server
}

pyright
sumneko_lua

nvim-packer
fzf
ale
commentary
neoformat

easyAlign
ultisnips
snippets
fugitive
delimitMate
multipleCursors
lightline
vim-closetag

# those 3 are required to work together
vim-javascript
# vim-jsx-pretty over vim-jsx for this reason: https://github.com/mxw/vim-jsx/issues/183
vim-jsx-pretty

monokai-tasty
vim-monokai
dracula

json
jsDoc

vim-go
gitgutter
vim-terraform

vim-markdown
markdown-preview
vim-subversive
vim-indentline
vim-highlightedyank

# requires nvim <= v0.5
vim-minimap
