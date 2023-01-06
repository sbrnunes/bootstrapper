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


main() {
  info "Installing Zsh"; # -------------------------------------------------------------------------
  brew install zsh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  /bin/bash -c $(which zsh)
  source ~/.zshrc

  /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting)"
  /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions)"
  /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions)"

  cp ../templates/.zshrc ~/.zshrc
  touch ~/.env.sh

  #cp ./templates/.env.sh ~/.env.sh

  source ~/.zshrc
}

main "$@";