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

main() {
  init_logger
  info "Running '$bootstrapper' for group '$group'"
  info "This bootstrapper is going to generate a new GPG key"; # -------------------------------------------------------------------------
  info "Would you like to continue?"
  while true; do
    read -p "$prefix Enter [y|n]:" answer
    case $answer in
      [Yy])
        if [[ $(type -t brew) = "" ]] && [ ! -f /opt/homebrew/bin/brew ]
        then
            info "Cannot run this bootstrapper. Install required dependency first: Homebrew."
        else
          info "Installing gnupg..."
          brew install gnupg

          grep -q "GPG_TTY" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo "### gnupg"
            echo 'export GPG_TTY=$(tty)' >> $HOME/env.sh
          fi

          info "Generating GPG key..."
          read -p "$prefix Type in your Real Name: " name
          read -p "$prefix Type in your Email: " email
          read -s -p "$prefix Type in a Passphrase: " passphrase

          # Based on https://www.gnupg.org/documentation/manuals/gnupg/Unattended-GPG-key-generation.html#Unattended-GPG-key-generation
          gpg --batch --gen-key << END
  Key-Type: 1
  Key-Length: 4096
  Name-Real: ${name}
  Name-Email: ${email}
  Expire-Date: 0
  Passphrase: ${passphrase}
END

          info "Fetching the key id..."
          key_id=$( gpg --list-secret-keys --with-colons | awk -F: '/^sec:/ { print $5 }' | tail -1 )

          info "Exporting the public certificate key $key_id..."
          public_key=$(gpg --armor --export $key_id | awk 'NF {sub(/\r/, ""); printf "%s",$0;}' | sed -E 's/-----(BEGIN|END) PGP PUBLIC KEY BLOCK-----//g')

	  info "Using github token: $GITHUB_TOKEN"

          grep -q "GITHUB_TOKEN" "$HOME/env.sh"
          if [ $? == 0 ]
          then
            if [[ -z "${GITHUB_TOKEN}" ]]
            then
              info "GITHUB_TOKEN was found in $HOME/env.sh but not in the current shell. Sourcing $HOME/env.sh..."
              source $HOME/env.sh
            fi

            info "Creating a GPG key in your GitHub User using the public key just created..."
            read -p "$prefix Type in the name of this GPG Key: " key_name
            curl \
            -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $GITHUB_TOKEN"\
            -H "X-GitHub-Api-Version: 2022-11-28" \
            https://api.github.com/user/gpg_keys \
            -d '{"name":"$key_name","armored_public_key":"-----BEGIN PGP PUBLIC KEY BLOCK-----\n\n'$public_key'\n-----END PGP PUBLIC KEY BLOCK-----"}'
          else
            if [[ -z "${GITHUB_TOKEN}" ]]
            then
              info "GITHUB_TOKEN was not found in $HOME/env.sh or in the current shell. Go to https://github.com/settings/keys and create the GPG Key manually using the public key below."
              echo "$(public_key)"
            fi 
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
