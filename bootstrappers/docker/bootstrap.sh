#!/usr/bin/env bash

scriptName="$(basename "$0")";
bootstrapper="$(basename "$(dirname "$0")")"

init_logger() {
  local cols=$(tput cols);
  local len=${#1};
  local prefixLen=${#prefix};
  prefix="$(tput setaf 13)[./bootstrappers/${bootstrapper}/${scriptName}]$(tput sgr0)"
}

info() {
  echo "$prefix $1";
}

main() {
  init_logger
  info "This bootstrapper is going to install and start Docker for Mac";
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

          info "Installing Docker";
          brew install --cask docker

          info "Starting Docker";
          open /Applications/Docker.app

          info "Enabling COMPOSE_DOCKER_CLI_BUILD and DOCKER_BUILDKIT...";
          grep -q "COMPOSE_DOCKER_CLI_BUILD" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo 'export COMPOSE_DOCKER_CLI_BUILD=1' >> $HOME/.env.sh
          fi

          grep -q "DOCKER_BUILDKIT" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo 'export DOCKER_BUILDKIT=1' >> $HOME/.env.sh
          fi
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