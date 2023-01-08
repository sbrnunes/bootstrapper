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
  info "This bootstrapper is going to download and install Ruby and rbenv via Homebrew"; # -------------------------------------------------------------------------
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

          brew install rbenv ruby-build rbenv-default-gems rbenv-gemset

          grep -q 'eval "$(rbenv init -)"' "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo 'eval "$(rbenv init -)"' >> $HOME/env.sh
          fi
          
          info "Restart the terminal to load rbenv."
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