installationRoot=$1
echo installationRoot $installationRoot
bundlePath=$2
echo bundlePath $bundlePath
currentFolder=$PWD
echo currentFolder $currentFolder

function clone {
  echo Cloning $2 to $dest
  local dest=$bundlePath
  echo dest $dest
  if [ -d $dest/$2 ]; then
    rm -rf $dest/$2
  fi
  mkdir -p $dest
  pushd $dest
  git clone https://github.com/$1
  popd # $dest
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
  mkdir -p $bundlePath
  pushd $bundlePath
  curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz|tar xzfv -
  popd # $bundlePath

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
  clone junegunn/vim-easy-align.git vim-easy-align
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

  # mkdir -p $bundlePath/ale/start
  # pushd $bundlePath/ale/start
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

function vim-terraform-lsp {
  echo installing terraform-lsp
  mkdir $HOME/terraform-lsp
  pushd $HOME/terraform-lsp
  wget https://github.com/juliosueiras/terraform-lsp/releases/download/v0.0.10/terraform-lsp_0.0.10_linux_amd64.tar.gz
  tar -xvf terraform-lsp_0.0.10_linux_amd64.tar.gz
  mkdir -p $HOME/bin
  ln -sfv $HOME/terraform-lsp/terraform-lsp $HOME/bin/terraform-lsp
  rm terraform-lsp_0.0.10_linux_amd64.tar.gz
  popd
}


# nerdtree
# fzf
# coc
# ale
# commentary
# neoformat

# easyAlign
# ultisnips
# snippets
# fugitive
# delimitMate
# multipleCursors
# lightline
# vim-closetag

# # those 3 are required to work together
# vim-javascript
# # vim-jsx-pretty over vim-jsx for this reason: https://github.com/mxw/vim-jsx/issues/183
# vim-jsx-pretty
# monokai-tasty

# json
# jsDoc

# vim-go
vim-terraform
vim-terraform-lsp
