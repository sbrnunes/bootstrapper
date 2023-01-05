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
  info "Configuring jenv"; # --------------------------------------------------------------------------

  brew install openjdk@11

  brew install jenv

  # If the ~/.jenv/versions folder is empty, add all of the current JDK installations into jenv.
  if [ -z "$(find "${HOME}/.jenv/versions" -mindepth 1 -maxdepth 1 -print -quit 2> /dev/null)" ]; then
    while IFS= read -r -d $'\n' jdk; do
      if [ -d "${jdk}/Contents/Home/bin" ]; then
        jenv add "${jdk}/Contents/Home";
      fi;
    done < <(find /Library/Java/JavaVirtualMachines -type d -maxdepth 1 -mindepth 1 -print);
  fi;

  # Default to Java 11.
  if [ ! -r "${HOME}/.jenv/version" ]; then
    jenv global 11;
    jenv rehash;
  fi;
}

main "$@";