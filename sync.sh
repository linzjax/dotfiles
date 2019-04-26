#!/bin/bash
cd "$(dirname "$0")" || exit 5
git pull

function doIt() {
  if [ ! -d ~/code ]; then
    mkdir ~/code
  fi
  if [ ! -d ~/.logs ]; then
    mkdir ~/.logs
    chmod 700 ~/.logs
  fi

  rsync --exclude ".git/" \
        --exclude "sync.sh" \
        --exclude "README.md" \
        --exclude "brew.txt" \
        --exclude "cask.txt" \
        --exclude "setup-macbook" \
        --exclude "install-atom-plugins.sh" \
        --exclude "npm-install.sh" \
        --exclude ".gitconfig" \
        -av . ~
  if [ ! -f ~/.gitconfig ]; then
    cp .gitconfig ~/.gitconfig
  fi

  # Atom
  if command -v apm > /dev/null 2>&1; then
    echo "Installing Atom plugins..."
    ~/code/dotfiles/install-atom-plugins.sh
  fi
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt
  fi
fi

unset doIt
source ~/.bash_profile
