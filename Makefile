##@ Help

.PHONY: help
help:  ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Bootstrappers

all: ## Installs all the tools supported by this project
	./bootstrap.sh

xcode:  ## Installs XCode Command Line Tools
	./bootstrappers/xcode/bootstrap.sh

homebrew:  ## Installs Homebrew
	./bootstrappers/homebrew/bootstrap.sh

iterm:  ## Installs iTerm2
	./bootstrappers/iterm/bootstrap.sh

zsh:  ## Installs Z Shell
	./bootstrappers/zsh/bootstrap.sh

gpg:  ## Generates a GPG key according to some standards
	./bootstrappers/bootstrap-gpg.sh

vscode:  ## Installs Visual Studio Code
	./bootstrappers/vscode/bootstrap.sh

ruby:  ## Installs Ruby and rbenv
	./bootstrappers/ruby/bootstrap.sh

jdk:  ## Installs OpenJDK 11 and jenv
	./bootstrappers/jdk/bootstrap.sh

docker:  ## Installs Docker for Mac
	./bootstrappers/docker/bootstrap.sh