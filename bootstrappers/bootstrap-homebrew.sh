#!/usr/bin/env bash

scriptName="$(basename "$0")";

info() {
  local cols=$(tput cols);
  local len=${#1};
  local prefix="[${scriptName}]";
  local prefixLen=${#prefix};
  local rem=$((${cols:-79}-len-prefixLen-2)); # 2 => spaces.
  local rhs="$(printf "%${rem}s" '' | tr ' ' '=')";
  # 13 is bright yellow green.
  echo "$(tput setaf 13)${prefix}$(tput sgr0) $1 $(tput setaf 13)${rhs}$(tput sgr0)";
}

add_brew_to_path() {
  echo '# Set PATH, MANPATH, etc., for Homebrew.' >> $1
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $1
}

main() {
  SUDO_USER=$(whoami);

  if ! type -t brew; then
    info "Downloading and installing brew"; # -------------------------------------------------------------
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    if [ ! $? -eq 0 ] 
    then
        info "Failed to install Homebrew"
        exit 1
    fi
  else
    info "Homebrew already installed!"
  fi;

  echo 'PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile;

  add_brew_to_path $HOME/.zprofile;
  add_brew_to_path $HOME/.bash_profile;
  add_brew_to_path $HOME/.zshrc

  eval "$(/opt/homebrew/bin/brew shellenv)"

  brew update;

  info "Installing some base packages...";

  PACKAGES=(
    awscli
    cask
    cookiecutter
    git
    grafana
    jq
    kubernetes-cli
    kubernetes-helm
    node
    openssl
    python3
    pyenv
    terraform
    tree
    watch
    wget
  );
  
  brew install "${PACKAGES[@]}";

  brew cleanup;
}

main "$@";