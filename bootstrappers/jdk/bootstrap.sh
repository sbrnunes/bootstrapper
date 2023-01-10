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
  info "This bootstrapper is going to download and install the JDK and jenv via Homebrew"; # -------------------------------------------------------------------------
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

          info "Installing openjdk 11..."
          brew install openjdk@$DEFAULT_JDK_VERSION

          info "Symlinking openjdk from Homebrew so that system java wrappers can find it ..."
          sudo ln -sfn /opt/homebrew/opt/openjdk@$DEFAULT_JDK_VERSION/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-$DEFAULT_JDK_VERSION.jdk

          info "Installing jEnv..."
          brew install jenv

          grep -q 'eval "$(jenv init -)"' "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo '### JDK' >> $HOME/env.sh
            echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> $HOME/env.sh
            echo 'eval "$(jenv init -)"' >> $HOME/env.sh
          fi

          eval "$(jenv init -)"

          info "Adding Java Virtual Machines from /Library/Java/JavaVirtualMachines to jEnv..."
          if [ -z "$(find "${HOME}/.jenv/versions" -mindepth 1 -maxdepth 1 -print -quit 2> /dev/null)" ]; then
            while IFS= read -r -d $'\n' jdk; do
              if [ -d "${jdk}/Contents/Home/bin" ]; then
                info "Adding ${jdk}..."
                jenv add "${jdk}/Contents/Home";
              fi;
            done < <(find /Library/Java/JavaVirtualMachines -maxdepth 1 -mindepth 1 -print);
          fi;

          info "jEnv is ready. Use 'jenv versions' to list all the available java versions."
          info "Use 'jenv help' for help with using this tool."
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