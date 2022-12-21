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

  local defaultDest="$(basename "$1" .git)"
  # echo default $defaultDest

  # substiture 3rd parameter if not provided
  local dest=${3:-$defaultDest}
  # echo dest $dest
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

  rm -rf $HOME/.fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf

  $HOME/.fzf/install --key-bindings --completion --update-rc

  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
  sudo dpkg -r ripgrep
  sudo dpkg -i ripgrep_13.0.0_amd64.deb
  rm ripgrep_13.0.0_amd64.deb

  # grep -qxF 'export FZF_DEFAULT_OPTS="--extended"' $HOME/.bashrc || echo 'export FZF_DEFAULT_OPTS="--extended"' >> $HOME/.bashrc
  # for the quoting escape black magic fuckery : https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
  # grep -qxF 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' $HOME/.bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >> $HOME/.bashrc

  # for the quoting escape black magic fuckery : https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
  grep -qF 'export FZF_DEFAULT_OPTS' $HOME/.bashrc || echo 'export FZF_DEFAULT_OPTS="--extended --preview '"'"'cat {}'"'"'"' >> $HOME/.bashrc
  grep -qF 'export FZF_DEFAULT_COMMAND="rg' $HOME/.bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >> $HOME/.bashrc

  source $HOME/.bashrc
}

# ultisnips() {
#   echo installing 'ultisnips'
#   clone SirVer/ultisnips.git ultisnips

#   # also adding custom snippets
#   # in order to work, the array g:UltiSnipsSnippetDirectories must contain "jf-snippets". Done in .vimrc
#   pushd $INSTALL_VI_BUNDLEPATH
#   rm -f vim-jfsnippets
#   ln -s $currentFolder/vim-jfsnippets vim-jfsnippets
#   popd
# }

# snippets() {
#   echo installing 'snippets'
#   clone honza/vim-snippets.git vim-snippets
# }


# neoformat() {
#   echo installing 'neoformat'
#   echo installer npm prettier globally first
#   npm -g install prettier

#   # local dest=$currentFolder
#   # pushd $HOME
#   # ln -s $dest/.prettierrc .prettierrc
#   # popd

#   clone sbdchd/neoformat.git neoformat
# }


# json() {
#   echo installing 'json'
#   clone elzr/vim-json.git vim-json
# }

# easyAlign() {
#   echo installing 'easyAlign'
#   clone junegunn/vim-easy-align.git vim-easy-align
# }

# fugitive() {
#   echo installing 'vim-fugitive'
#   clone tpope/vim-fugitive.git vim-fugitive
#   runCommand "helptags $INSTALL_VI_BUNDLEPATH/vim-fugitive/doc" 
# }

#solarized() {
#  # command to put in vimrc if I want to switch to solarized
#  #
#  # set background=dark
#  # " I want high contrast diffs
#  # let g:solarized_diffmode="high"
#  # colorscheme solarized

#  echo installing 'solarized' color scheme
#  clone altercation/vim-colors-solarized.git vim-colors-solarized
#}

# dracula() {
#   echo installing 'dracula' color scheme
#   clone dracula/vim.git dracula dracula
# }

# delimitMate() {
#   echo insalling delimitMate
#   clone Raimondi/delimitMate.git delimitMate

#   runCommand "helptags  $INSTALL_VI_BUNDLEPATH/delimitMate/doc"
# }


# lightline() {
#   echo installing lightline
#   clone itchyny/lightline.vim.git lightline.vim
# }

# vim-javascript() {
#   echo installing vim-javasript
#   clone pangloss/vim-javascript.git vim-javascript
# }

# vim-jsx-pretty() {
#   echo installing vim-jsx-pretty
#   clone MaxMEllon/vim-jsx-pretty.git vim-jsx-pretty
# }


# vim-go() {
#   echo installing vim-go
#   clone fatih/vim-go.git vim-go

#   runCommand "GoInstallBinaries"
# }
# gitgutter() {
#   echo installing git-gutter
#   clone airblade/vim-gitgutter.git vim-gitgutter
#   runCommand "helptags $INSTALL_VI_BUNDLEPATH/vim-gitgutter/doc" 
# }

# ale() {
#   echo installing ale
#   echo first, installing eslint
#   npm -g install eslint
#   # npm -g install eslint-plugin-prettier
#   # npm -g install eslint-config-prettier


#   # local dest=$currentFolder
#   # pushd $HOME
#   # ln -s $dest/.eslintrc .eslintrc
#   # popd

#   echo clonig ale

#   clone dense-analysis/ale.git ale

#   # mkdir -p $INSTALL_VI_BUNDLEPATH/ale/start
#   # pushd $INSTALL_VI_BUNDLEPATH/ale/start
#   # git clone https://github.com/w0rp/ale.git
#   # popd
# }

# vim-closetag() {
#   echo installing vim-closetag
#   clone alvan/vim-closetag.git vim-closetag
# }

# vim-terraform() {
#   echo installing vim-terraform
#   clone hashivim/vim-terraform.git vim-terraform
# }

# vim-markdown() {
#   echo installing vim-markdown
#   clone plasticboy/vim-markdown.git plasticboy/vim-markdown
# }

# markdown-preview() {

#   echo installing markdown-preview.nvim
#   clone iamcco/markdown-preview.nvim.git iamcco/markdown-preview.nvim

#   runCommand "call mkdp#util#install_sync()"
# }

# vim-subversive() {
#   echo installing vim-subversive

#   clone svermeulen/vim-subversive.git svermeulen/vim-subversive
# }


# vim-indentline() {

#   echo installing vim-indentline

#   clone Yggdroot/indentLine.git Yggdroot/indentLine

#   runCommand "helptags  $INSTALL_VI_BUNDLEPATH/indentLine/doc"
# }

# vim-highlightedyank() {
#   echo installing vim-highlightedyank.git

#   clone machakann/vim-highlightedyank.git machakann/vim-highlightedyank
# }

nvim-packer() {
  echo installing wbthomason/packer.nvim

  clone wbthomason/packer.nvim.git wbthomason/packer.nvim

}



nvim-packer

# environment related
fzf
vim-minimap
