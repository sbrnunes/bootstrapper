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
        if [ ! type -t brew ]
        then
          if [[ ! -e /opt/homebrew/bin/brew ]]
          then
            info "Cannot run this bootstrapper. Install required dependency first: Homebrew."
          else
            eval "$(/opt/homebrew/bin/brew shellenv)"

            brew install rbenv ruby-build rbenv-default-gems rbenv-gemset
            echo '### rbenv' $HOME/env.sh
            echo 'eval "$(rbenv init -)"' >> $HOME/env.sh
            source $HOME/env.sh
          fi
        fi
      ;;
      [Nn]) 
        info "Skipping...";
        break;
      ;;
    esac
  done
}

main "$@";