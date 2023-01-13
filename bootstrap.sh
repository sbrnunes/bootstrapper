#!/usr/bin/env bash

scriptName="$(basename "$0")";

init_logger() {
  local cols=$(tput cols);
  local len=${#1};
  local prefixLen=${#prefix};
  prefix="$(tput setaf 13)[./${scriptName}]$(tput sgr0)"
}

info() {
  echo "$prefix $1";
}

main() {
  shopt -u nullglob
  init_logger
  groups=$(cat config)
  for group in $groups
  do
    info "Boostrapping group $group. Would you like to continue?"
    while true; do
      read -p "$prefix Enter [y|n]: " answer
      case $answer in
        [Yy])
          bootstrappers=$(cat ./groups/$group/config)
          for bootstrapper in $bootstrappers
          do
            /bin/bash -c "./bootstrappers/$bootstrapper/bootstrap.sh $group";
          done
          break;
        ;;
        [Nn])
          info "Skipping...";
          break;
        ;;
      esac
    done
  done
  info "Boostrapping completed. Please, restart you terminal!"
  shopt -u nullglob
}

main "$@";