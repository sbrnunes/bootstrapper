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
  info "[EXPERIMENTAL] This bootstrapper is going to generate a new GPG key"; # -------------------------------------------------------------------------
  info "Would you like to continue?"
  while true; do
    read -p "$prefix Enter [y|n]:" answer
    case $answer in
      [Yy])
        read -p "$prefix Type in your Real Name: " name
        read -p "$prefix Type in your Email: " email
        read -s -p "$prefix Type in a Passphrase: " passphrase

        # Based on https://www.gnupg.org/documentation/manuals/gnupg/Unattended-GPG-key-generation.html#Unattended-GPG-key-generation

        info "Generating GPG key..."
:wq
        gpg --batch --gen-key <<END
    Key-Type: 1
    Key-Length: 4096
    Name-Real: ${name}
    Name-Email: ${email}
    Expire-Date: 0
    Passphrase: ${passphrase}
END

        info "Listing all GPG keys..."
        gpg --list-secret-keys --keyid-format=long

        info "Run 'gpg --armor --export <id>' to get the public certificate."

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