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

main() {
  init_logger
  info "This bootstrapper is going to download and install iterm2 via Homebrew."; # -------------------------------------------------------------------------
  info "Would you like to continue?"
  while true; do
    read -p "$prefix Enter [y|n]:" answer
    case $answer in
      [Yy])
        if [[ $(type -t brew) = "" ]] && [ ! -f /opt/homebrew/bin/brew ]
        then
            info "Cannot run this bootstrapper. Install required dependency first: Homebrew."
        else
          eval "$(/opt/homebrew/bin/brew shellenv)"

          info "Installing iterm2"; # -------------------------------------------------------------------------
          brew install --cask iterm2
          brew tap homebrew/cask-fonts
          brew install --cask font-source-code-pro
        fi
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
