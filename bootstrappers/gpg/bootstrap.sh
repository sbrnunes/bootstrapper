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
            echo "export GPG_TTY=$(tty)" >> $HOME/env.sh
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
          publick_key=$(gpg --armor --export $key_id)

          info "Pushing the public certificate to GitHub..."
          curl \
          -X POST \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer $(echo $GITHUB_TOKEN)"\
          -H "X-GitHub-Api-Version: 2022-11-28" \
          https://api.github.com/user/gpg_keys \
          -d '{"name":"Octocat'\''s GPG Key","armored_public_key":"'$public_key'"}'
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