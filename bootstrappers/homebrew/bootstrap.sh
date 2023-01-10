#!/usr/bin/env bash

scriptName="$(basename "$0")";
bootstrapper="$(basename "$(dirname "$0")")"
group="$1"

init_logger() {
  local cols=$(tput cols);
  local len=${#1};
  local prefixLen=${#prefix};
  prefix="$(tput setaf 13)[./bootstrappers/${bootstrapper}/${scriptName}]$(tput sgr0)"
}

info() {
  echo "$prefix $1";
}

init_brew() {
  # env.sh will be a convention, agnostic from the shell
  [[ -e $HOME/env.sh ]] || touch $HOME/env.sh # create if does not exist

  if grep -q "/opt/homebrew/bin/brew" "$HOME/env.sh" ; then
    info 'Found eval "$(/opt/homebrew/bin/brew shellenv)" in '"$HOME/env.sh"
  else
    info 'Adding eval "$(/opt/homebrew/bin/brew shellenv)" to '"$HOME/env.sh"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/env.sh
    info "Loading $HOME/env.sh"
    source $HOME/env.sh
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"
}

main() {
  init_logger
  info "Running '$bootstrapper' for group '$group'"
  info "This bootstrapper is going to install homebrew and some base packages."; # -------------------------------------------------------------------------
  info "Would you like to continue?"
  while true; do
    read -p "$prefix Enter [y|n]:" answer
    case $answer in
      [Yy])
        SUDO_USER=$(whoami);
        if [[ $(type -t brew) = "" ]] && [ ! -f /opt/homebrew/bin/brew ]
        then
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

        init_brew

        brew update;

        info "Installing required packages...";
        brew tap Homebrew/bundle
        brew bundle --file="./groups/$group/Brewfile"

        brew cleanup;
        break;
      ;;
      [Nn]) 
        info "Skipping...";
        break;
      ;;
    esac
  done
}

main "$@";