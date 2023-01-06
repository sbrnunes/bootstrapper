#!/usr/bin/env bash

scriptName="$(basename "$0")";

init_logger() {
  local cols=$(tput cols);
  local len=${#1};
  local prefixLen=${#prefix};
  prefix="$(tput setaf 13)[${scriptName}]$(tput sgr0)"
}

info() {
  echo "$prefix $1";
}

set_path() {
  if [[ -e $1 ]]
  then
    if grep -q "/opt/homebrew/bin/brew" "$1" ; then
      info 'Found eval "$(/opt/homebrew/bin/brew shellenv)" in '"$1"
    else
      info 'Adding eval "$(/opt/homebrew/bin/brew shellenv)" to '"$1"
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $1
      info "Loading $1"
      source "$1"
      if ! type -t brew; then
        info "Warning: brew not loaded properly to the path."
      fi;
    fi
  fi
}

main() {
  init_logger
  info "This bootstrapper is going to install homebrew and some base packages."; # -------------------------------------------------------------------------
  info "Would you like to continue?"
  while true; do
    read -p "$prefix Enter [y|n]:" answer
    case $answer in
      [Yy])
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

        set_path $HOME/.env.sh;
        set_path $HOME/.zprofile;
        set_path $HOME/.bash_profile;
        set_path $HOME/.zshrc

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
      ;;
      [Nn]) 
        info "Skipping...";
        break;
      ;;
    esac
  done
}

main "$@";