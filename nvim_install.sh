#!/bin/bash


installationRoot=$HOME/.config/nvim
rm -rf $installationRoot

if [ ! -d $installationRoot ]; then
  mkdir -p $installationRoot
fi

bundlePath=$installationRoot/bundle
nativeBundlePath=$HOME/.local/share/nvim/site/pack

# currentFolder=$HOME/ubuntu-vim-nodejs
currentFolder=$PWD

sudo apt install neovim
sudo apt install python-neovim
sudo apt install python3-neovim

# https://github.com/neovim/neovim/wiki/Installing-Neovim
# Do I really want that?
# sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
# sudo update-alternatives --config vi
# sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
# sudo update-alternatives --config vim
# sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
# sudo update-alternatives --config editor

function clone {
  echo Cloning path $2
  local dest=$bundlePath/$2
  if [ -d $dest ]; then
    rm -rf $dest
  fi
  pushd $bundlePath
  git clone https://github.com/$1
  popd

}

function pathogen {
  echo installing 'pathogen'
  mkdir -p $installationRoot/autoload $bundlePath && \
  curl -LSso $installationRoot/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

function fzf {
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install

  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
  sudo dpkg -i ripgrep_11.0.2_amd64.deb
  rm ripgrep_11.0.2_amd64.deb

  grep -qxF 'export FZF_DEFAULT_OPTS="--extended"' $HOME/.bashrc || echo 'export FZF_DEFAULT_OPTS="--extended"' >> $HOME/.bashrc
  # for the quoting escape black magic fuckery : https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
  grep -qxF 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' $HOME/.bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >> $HOME/.bashrc

  clone junegunn/fzf.vim fzf.vim
}

function nerdtree {
  echo installing 'nerdtree'
  clone scrooloose/nerdtree.git nerdtree
}

function ultisnips {
  echo installing 'ultisnips'
  clone SirVer/ultisnips.git ultisnips

  # also adding custom snippets
  # in order to work, the array g:UltiSnipsSnippetDirectories must contain "jf-snippets". Done in .vimrc
  pushd $bundlePath
  ln -s $currentFolder/vim-jfsnippets vim-jfsnippets
  popd

}

function coc {
  echo installing 'coc'

  local dest=$currentFolder

  # source: https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim
  mkdir -p $nativeBundlePath/coc/start
  pushd $nativeBundlePath/coc/start
  curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz|tar xzfv -
  popd # $nativeBundlePath/coc/start

  mkdir -p $HOME/.config/coc/extensions
  pushd $HOME/.config/coc/extensions
  if [ ! -f package.json ]
  then
    echo '{"dependencies":{}}'> package.json
  fi

  # Change extension names to the extensions you need
  npm install coc-tsserver --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
  npm install coc-json --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
  npm install coc-css --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

  popd # $HOME/.config/coc/extensions


  pushd $installationRoot
  ln -s $dest/coc-settings.json coc-settings.json
  popd
}

function snippets {
  echo installing 'snippets'
  clone honza/vim-snippets.git vim-snippets
}

function commentary {
  echo installing 'commentary'
  clone tpope/vim-commentary.git vim-commentary
}

function neoformat {
  echo installing 'neoformat'
  echo installer npm prettier globally first
  npm -g install prettier

  # local dest=$currentFolder
  # pushd $HOME
  # ln -s $dest/.prettierrc .prettierrc
  # popd

  clone sbdchd/neoformat.git neoformat
}

function jsDoc {
  echo installing 'jsDoc'
  clone heavenshell/vim-jsdoc.git vim-jsdoc
}

function json {
  echo installing 'json'
  clone elzr/vim-json.git vim-json
}

function easyAlign {
  echo installing 'easyAlign'
  clone junegunn/vim-easy-align vim-easy-align
}

function fugitive {
  echo installing 'vim-fugitive'
  clone tpope/vim-fugitive.git vim-fugitive
  vim -u NONE -c "helptags vim-fugitive/doc" -c q
}

function solarized {
  # command to put in vimrc if I want to switch to solarized
  #
  # set background=dark
  # " I want high contrast diffs
  # let g:solarized_diffmode="high"
  # colorscheme solarized

  echo installing 'solarized' color scheme
  clone altercation/vim-colors-solarized.git vim-colors-solarized
}

function monokai-tasty {
  echo installing 'monokai-tasty' color scheme
  clone patstockwell/vim-monokai-tasty.git vim-monokai-tasty.vim
}

function delimitMate {
  echo insalling delimitMate
  clone Raimondi/delimitMate.git delimitMate
}

function multipleCursors {
  echo installing vim-multiple-cursors
  clone terryma/vim-multiple-cursors.git vim-multiple-cursors
}

function lightline {
  echo installing lightline
  clone itchyny/lightline.vim lightline.vim
}

function vim-javascript {
  echo installing vim-javasript
  clone pangloss/vim-javascript.git vim-javascript
}

function vim-jsx-pretty {
  echo installing vim-jsx-pretty
  clone MaxMEllon/vim-jsx-pretty.git MaxMEllon/vim-jsx-pretty
}

function ale {
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

  mkdir -p $nativeBundlePath/ale/start
  pushd $nativeBundlePath/ale/start
  git clone https://github.com/w0rp/ale.git
  popd
}

function vimrc {
  local dest=$currentFolder

  pushd $installationRoot

  echo Symlinking init.vim
  ln -s $dest/init.vim init.vim

  popd
}

pathogen

nerdtree
fzf
coc
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

# those 3 are required to work together
vim-javascript
# vim-jsx-pretty over vim-jsx for this reason: https://github.com/mxw/vim-jsx/issues/183
vim-jsx-pretty
monokai-tasty

json
jsDoc

vimrc
