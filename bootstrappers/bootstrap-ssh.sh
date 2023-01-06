#!/usr/bin/env bash

shopt -s nullglob

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
  info "This bootstrapper is going to provision the required ssh keys in your machine."; # -------------------------------------------------------------------------
  info "Would you like to continue?"
  while true; do
    read -p "$prefix Enter [y|n]:" answer
    case $answer in
      [Yy])
        keys=( $HOME/.ssh/id_ed25519_td* )

        if [[ "${#keys[@]}" -eq 0 ]]
        then
          key_name="$HOME/.ssh/id_ed25519_td_$(date +%Y-%m-%d)"

          info "Generating SSH Key for $(whoami) in $key_name using algorithm ED25519..."

          # Creates directory if it does not exist
          if [ ! -d $HOME/.ssh ]
          then
            info "Creating $HOME/.ssh"
            mkdir $HOME/.ssh
          fi

          ssh-keygen -t ed25519 -f $key_name -C "Public/Private key for $(whoami)"

          info "Securing the ~/.ssh folder and its contents..."

          chmod 700 $HOME/.ssh
          chmod 600 $HOME/.ssh/*
          chown -R $USER $HOME/.ssh

          info "Adding privates keys to the ssh agent..."

          for file in "${keys[@]}"
          do
            case $file in !*pub*)
              info "Adding $file..."
              #ssh-add -K $file
            esac
          done

          info "Take a moment to add the public key to your GitHub instance, if needed:"
          echo $(cat "$key_name.pub")
          info "Press any key to continue..."
          read
        else
          info "SSH keys have been found inside ~/.ssh, skipping..."
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
