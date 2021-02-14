# taken here: https://unix.stackexchange.com/questions/228331/avoid-running-the-script-if-a-variable-is-not-defined
set -u # or set -o nounset
echo INSTALL_VI_ROOTPATH $INSTALL_VI_ROOTPATH
echo INSTALL_VI_BUNDLEPATH $INSTALL_VI_BUNDLEPATH
echo INSTALL_VI_TARGET $INSTALL_VI_TARGET

currentFolder=$PWD
echo currentFolder $currentFolder

function clone {

  # $1 repo path to clone
  # $2 friendly name of the repo
  # $3 -optionnal- the destination directory. uses the git clone default behavior if not provided

  local defaultDest=$(basename $1 .git)
  # echo default $defaultDest

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

function runCommand {
  echo "Running command $1"
  bash -c "$INSTALL_VI_TARGET -U NONE --cmd \"$1\" --cmd \"qa\""
}

function fzf {
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
  grep -qF 'export FZF_DEFAULT_OPTS' $HOME/.bashrc || echo 'export FZF_DEFAULT_OPTS="--extended" --preview '"'"'cat {}'"'" >> $HOME/.bashrc
  grep -qF 'export FZF_DEFAULT_COMMAND="rg' $HOME/.bashrc || echo 'export FZF_DEFAULT_COMMAND="rg --files --smart-case --hidden -g '"'"'!.git'"'"'"' >> $HOME/.bashrc

  source $HOME/.bashrc

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
  pushd $INSTALL_VI_BUNDLEPATH
  ln -s $currentFolder/vim-jfsnippets vim-jfsnippets
  popd
}

function coc {
  echo installing 'coc'

  # source: https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim
  mkdir -p $INSTALL_VI_BUNDLEPATH
  pushd $INSTALL_VI_BUNDLEPATH
  curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz|tar xzfv -
  popd # $INSTALL_VI_BUNDLEPATH

  rm -rf $HOME/.config/coc
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
  npm install coc-pyright --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
  npm install coc-snippets --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
  npm install coc-yaml --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

  popd # $HOME/.config/coc/extensions


  pushd $INSTALL_VI_ROOTPATH
  rm coc-settings.json
  ln -s $currentFolder/coc-settings.json coc-settings.json
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
  clone junegunn/vim-easy-align.git vim-easy-align
}

function fugitive {
  echo installing 'vim-fugitive'
  clone tpope/vim-fugitive.git vim-fugitive
  runCommand "helptags $INSTALL_VI_BUNDLEPATH/vim-fugitive/doc" 
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

function vim-monokai {
  echo installing 'vim-monokai' color scheme
  clone crusoexia/vim-monokai.git vim-monokai
}

function dracula {
  echo installing 'dracula' color scheme
  clone dracula/vim.git dracula dracula
}

function delimitMate {
  echo insalling delimitMate
  clone Raimondi/delimitMate.git delimitMate

  runCommand "helptags  $INSTALL_VI_BUNDLEPATH/delimitMate/doc"
}

function multipleCursors {
  echo installing vim-multiple-cursors
  clone terryma/vim-multiple-cursors.git vim-multiple-cursors
}

function lightline {
  echo installing lightline
  clone itchyny/lightline.vim.git lightline.vim
}

function vim-javascript {
  echo installing vim-javasript
  clone pangloss/vim-javascript.git vim-javascript
}

function vim-jsx-pretty {
  echo installing vim-jsx-pretty
  clone MaxMEllon/vim-jsx-pretty.git vim-jsx-pretty
}


function vim-go {
  echo installing vim-go
  clone fatih/vim-go.git vim-go

  runCommand "GoInstallBinaries"
}
function gitgutter {
  echo installing git-gutter
  clone airblade/vim-gitgutter.git vim-gitgutter
  runCommand "helptags $INSTALL_VI_BUNDLEPATH/vim-gitgutter/doc" 
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

  clone dense-analysis/ale.git ale

  # mkdir -p $INSTALL_VI_BUNDLEPATH/ale/start
  # pushd $INSTALL_VI_BUNDLEPATH/ale/start
  # git clone https://github.com/w0rp/ale.git
  # popd
}

function vim-closetag {
  echo installing vim-closetag
  clone alvan/vim-closetag.git vim-closetag
}

function vim-terraform {
  echo installing vim-terraform
  clone hashivim/vim-terraform.git vim-terraform
}

function vim-markdown {
  echo installing vim-markdown
  clone plasticboy/vim-markdown.git plasticboy/vim-markdown
}

function markdown-preview {

  echo installing markdown-preview.nvim
  clone iamcco/markdown-preview.nvim.git iamcco/markdown-preview.nvim

  runCommand "call mkdp#util#install_sync()"
}

function vim-subversive {
  echo installing vim-subversive

  clone svermeulen/vim-subversive.git svermeulen/vim-subversive
}


function vim-indentline {

  echo installing vim-indentline

  clone Yggdroot/indentLine.git Yggdroot/indentLine

  runCommand "helptags  $INSTALL_VI_BUNDLEPATH/indentLine/doc"
}

function vim-highlightedyank {
  echo installing vim-highlightedyank.git

  clone machakann/vim-highlightedyank.git machakann/vim-highlightedyank

}


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
